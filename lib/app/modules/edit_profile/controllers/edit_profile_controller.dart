import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/child_progress_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final isLoading   = false.obs;
  final isParent    = false.obs;
  final photoUrl    = ''.obs;   // URL tersimpan (Firestore/Auth)
  final pickedFile  = Rxn<XFile>(); // file lokal yang baru dipilih

  final _auth     = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage  = FirebaseStorage.instance;
  final _picker   = ImagePicker();

  String? childId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      isParent.value = args['isParent'] == true;
      if (!isParent.value) {
        childId = args['childId'] as String?;
        nameController.text = args['currentName'] as String? ?? '';
      }
    }

    final user = _auth.currentUser;
    if (isParent.value || childId == null) {
      nameController.text = user?.displayName ?? '';
      photoUrl.value      = user?.photoURL ?? '';
    }
    // Load photoUrl from Firestore so it's always up-to-date
    _loadPhotoFromFirestore();
  }

  Future<void> _loadPhotoFromFirestore() async {
    try {
      final uid = (childId != null && !isParent.value)
          ? childId!
          : _auth.currentUser?.uid;
      if (uid == null) return;
      final snap = await _firestore.collection('users').doc(uid).get();
      final url = snap.data()?['photoUrl'] as String?;
      if (url != null && url.isNotEmpty) photoUrl.value = url;
    } catch (_) {}
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (file != null) pickedFile.value = file;
  }

  Future<String?> _uploadPhoto(String uid) async {
    final file = pickedFile.value;
    if (file == null) return null;
    final ref = _storage.ref().child('profile_photos/$uid.jpg');
    final task = await ref.putFile(
      File(file.path),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<void> saveProfile() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      Get.snackbar('Error', 'Nama tidak boleh kosong!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      String? newPhotoUrl;

      if (!isParent.value && childId != null) {
        // Edit profil anak oleh orang tua
        if (pickedFile.value != null) newPhotoUrl = await _uploadPhoto(childId!);
        final updates = <String, dynamic>{'name': newName};
        if (newPhotoUrl != null) updates['photoUrl'] = newPhotoUrl;
        await _firestore.collection('users').doc(childId)
            .set(updates, SetOptions(merge: true));
      } else {
        // Edit profil user yang sedang login (anak atau orang tua)
        final user = _auth.currentUser;
        if (user == null) return;

        if (pickedFile.value != null) newPhotoUrl = await _uploadPhoto(user.uid);

        await user.updateDisplayName(newName);
        if (newPhotoUrl != null) await user.updatePhotoURL(newPhotoUrl);
        await user.reload();

        final updates = <String, dynamic>{'name': newName};
        if (newPhotoUrl != null) updates['photoUrl'] = newPhotoUrl;
        await _firestore.collection('users').doc(user.uid)
            .set(updates, SetOptions(merge: true));

        // Perbarui ChildProgressService secara reaktif
        try {
          final svc = Get.find<ChildProgressService>();
          svc.childName.value = newName;
          if (newPhotoUrl != null) svc.photoUrl.value = newPhotoUrl;
        } catch (_) {}
      }

      if (newPhotoUrl != null) photoUrl.value = newPhotoUrl;

      Get.snackbar('Berhasil!', 'Profil berhasil diperbarui.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white);
      Get.back(result: newName);
    } catch (e) {
      debugPrint('Edit profile error: $e');
      Get.snackbar('Gagal', 'Terjadi kesalahan saat menyimpan profil.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
