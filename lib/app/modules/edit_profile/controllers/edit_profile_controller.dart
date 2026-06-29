import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final isLoading = false.obs;
  final isParent = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? childId;

  @override
  void onInit() {
    super.onInit();
    // Check if navigated with argument 'isParent'
    if (Get.arguments != null && Get.arguments is Map) {
      isParent.value = Get.arguments['isParent'] ?? false;
      
      if (!isParent.value) {
        childId = Get.arguments['childId'];
        nameController.text = Get.arguments['currentName'] ?? '';
      }
    }
    
    if (isParent.value || childId == null) {
      // Pre-fill current display name
      final user = _auth.currentUser;
      if (user != null && user.displayName != null) {
        nameController.text = user.displayName!;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      if (!isParent.value && childId != null) {
        // Edit Child Profile
        final docRef = _firestore.collection('users').doc(childId);
        final docSnap = await docRef.get();
        if (docSnap.exists) {
          await docRef.update({'name': newName});
        }
      } else {
        // Edit Parent/Current User Profile
        final user = _auth.currentUser;
        if (user == null) return;

        await user.updateDisplayName(newName);
        await user.reload();

        final docRef = _firestore.collection('users').doc(user.uid);
        final docSnap = await docRef.get();
        if (docSnap.exists) {
          await docRef.update({'name': newName});
        }
      }

      Get.snackbar(
        'Berhasil!',
        'Profil berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );

      Get.back(result: newName);
    } catch (e) {
      debugPrint('Edit profile error: $e');
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat menyimpan profil.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
