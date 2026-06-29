import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final parentName = ''.obs;
  final parentEmail = ''.obs;
  final children = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  // Real-time Progress Observables
  final sukuKataProgress = 0.obs; // %
  final kosakataProgress = 0.obs; // %
  final rimaProgress = 0.obs; // %
  final fonemProgress = 0.obs; // %
  
  // Derived Statistics Observables
  final fokusAnak = 0.obs; // %
  final kecepatanMembaca = 0.obs; // %
  final pengenalanHuruf = 0.obs; // %
  
  final kataSulit = <Map<String, dynamic>>[].obs;
  
  final currentCarouselIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadParentData();
  }

  Future<void> _loadParentData() async {
    final user = _auth.currentUser;
    if (user != null) {
      parentName.value = user.displayName ?? 'Orang Tua';
      parentEmail.value = user.email ?? '';
      
      // Load linked children and listen for real-time updates
      try {
        _firestore
            .collection('users')
            .where('role', isEqualTo: 'child')
            .where('parentId', isEqualTo: user.uid)
            .snapshots()
            .listen((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            final childData = querySnapshot.docs.first.data();
            print('--- PARENT DASHBOARD RAW DATA ---');
            print(childData);
            print('---------------------------------');
            children.value = querySnapshot.docs.map((doc) => doc.data()).toList();
            
            // Perbarui statistik secara realtime jika ada data di database
            if (childData.containsKey('stats')) {
              final stats = childData['stats'] as Map<String, dynamic>;
              sukuKataProgress.value = (stats['sukuKata'] as num?)?.toInt() ?? 0;
              kosakataProgress.value = (stats['kosakata'] as num?)?.toInt() ?? 0;
              rimaProgress.value = (stats['rima'] as num?)?.toInt() ?? 0;
              fonemProgress.value = (stats['fonem'] as num?)?.toInt() ?? 0;
              
              final correct = (stats['totalCorrect'] as num?)?.toInt() ?? 0;
              final wrong = (stats['totalWrong'] as num?)?.toInt() ?? 0;
              final total = correct + wrong;
              if (total > 0) {
                fokusAnak.value = ((correct / total) * 100).toInt();
              } else {
                fokusAnak.value = 0;
              }
              
              kecepatanMembaca.value = ((rimaProgress.value + sukuKataProgress.value) / 2).toInt();
              pengenalanHuruf.value = fonemProgress.value;
            } else {
              sukuKataProgress.value = 0;
              kosakataProgress.value = 0;
              rimaProgress.value = 0;
              fonemProgress.value = 0;
              
              fokusAnak.value = 0;
              kecepatanMembaca.value = 0;
              pengenalanHuruf.value = 0;
            }

            if (childData.containsKey('kataSulit')) {
              kataSulit.value = List<Map<String, dynamic>>.from(childData['kataSulit']);
            } else {
              kataSulit.clear();
            }
          }
        });
      } catch (e) {
        print('Error loading children: $e');
      }
    }
    isLoading.value = false;
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/welcome');
  }
}
