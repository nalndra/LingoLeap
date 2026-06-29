import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../../../services/child_progress_service.dart';
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    Future.delayed(const Duration(milliseconds: 500), () {
      emailController.dispose();
      passwordController.dispose();
    });
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Kunci Rahasia tidak boleh kosong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Auto-migrate legacy accounts that don't have a Firestore document
      final uid = userCredential.user?.uid;
      final displayName = userCredential.user?.displayName ?? 'Pahlawan';
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'name': displayName,
            'email': email,
            'role': 'child',
            'level': 1,
            'xp': 0,
            'parentId': null,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.offAllNamed(Routes.VERIFY_EMAIL);
        return;
      }

      Get.snackbar(
        'Sukses',
        'Selamat datang kembali, ${user?.displayName ?? "Pahlawan"}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Pre-load stats before navigating so games don't start at 0 if the user clicks too fast
      try {
        await Get.find<ChildProgressService>().loadChildStats();
      } catch (_) {}

      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan saat masuk.';
      if (e.code == 'user-not-found') {
        message = 'Email pahlawan tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Kunci rahasia salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      }
      Get.snackbar(
        'Gagal Masuk',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }
}
