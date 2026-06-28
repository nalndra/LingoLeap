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
  final sukuKataProgress = 85.obs; // %
  final fokusAnak = 50.obs; // %
  final kecepatanMembaca = 76.obs; // %
  final pengenalanHuruf = 85.obs; // %
  
  final kataSulit = <Map<String, dynamic>>[
    {'word': 'Strategi', 'count': 2},
    {'word': 'Mengapa', 'count': 4},
    {'word': 'Palu', 'count': 3},
    {'word': 'Bagi', 'count': 1},
  ].obs;

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
            children.value = querySnapshot.docs.map((doc) => doc.data()).toList();
            
            // Perbarui statistik secara realtime jika ada data di database (fallback ke default jika tidak ada)
            if (childData.containsKey('stats')) {
              final stats = childData['stats'];
              sukuKataProgress.value = stats['sukuKata'] ?? 85;
              fokusAnak.value = stats['fokus'] ?? 50;
              kecepatanMembaca.value = stats['kecepatan'] ?? 76;
              pengenalanHuruf.value = stats['pengenalanHuruf'] ?? 85;
            }
            if (childData.containsKey('kataSulit')) {
              kataSulit.value = List<Map<String, dynamic>>.from(childData['kataSulit']);
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
