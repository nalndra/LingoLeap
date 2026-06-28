import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/pin_service.dart';

class ParentSettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final parentName = ''.obs;
  final parentEmail = ''.obs;
  final children = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Load parent info from Firestore first, fallback to Auth
      try {
        final parentDoc = await _firestore.collection('users').doc(user.uid).get();
        if (parentDoc.exists) {
          final data = parentDoc.data()!;
          parentName.value = data['name'] ?? user.displayName ?? 'Orang Tua';
          parentEmail.value = data['email'] ?? user.email ?? '';
        } else {
          parentName.value = user.displayName ?? 'Orang Tua';
          parentEmail.value = user.email ?? '';
        }
      } catch (e) {
        parentName.value = user.displayName ?? 'Orang Tua';
        parentEmail.value = user.email ?? '';
      }

      // Listen for linked children in realtime
      try {
        _firestore
            .collection('users')
            .where('role', isEqualTo: 'child')
            .where('parentId', isEqualTo: user.uid)
            .snapshots()
            .listen((querySnapshot) {
          children.value = querySnapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id;
            return data;
          }).toList();
        });
      } catch (e) {
        print('Error loading children: $e');
      }
    }
    isLoading.value = false;
  }

  void logout() async {
    try {
      Get.find<PinService>().clearLocalPin();
    } catch (_) {}
    await _auth.signOut();
    Get.offAllNamed('/welcome');
  }
}
