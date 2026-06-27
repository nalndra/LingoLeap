import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';
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
