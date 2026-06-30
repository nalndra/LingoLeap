import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/pin_service.dart';

class ParentLoginController extends GetxController {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading      = false.obs;
  final obscurePassword = true.obs;

  // Inline error strings
  final emailError  = ''.obs;
  final passError   = ''.obs;
  final serverError = ''.obs;

  final FirebaseAuth      _auth      = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailError.value.isNotEmpty) emailError.value = '';
      if (serverError.value.isNotEmpty) serverError.value = '';
    });
    passwordController.addListener(() {
      if (passError.value.isNotEmpty) passError.value = '';
      if (serverError.value.isNotEmpty) serverError.value = '';
    });
  }

  @override
  void onClose() {
    Future.delayed(const Duration(milliseconds: 500), () {
      emailController.dispose();
      passwordController.dispose();
    });
    super.onClose();
  }

  bool _validate() {
    bool ok = true;
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    if (email.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      ok = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Format email tidak valid';
      ok = false;
    }

    if (pass.isEmpty) {
      passError.value = 'Kata sandi tidak boleh kosong';
      ok = false;
    }

    return ok;
  }

  Future<void> login() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      final pass  = passwordController.text;

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      ).timeout(const Duration(seconds: 15));

      // Verify parent role
      final doc = await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (doc.exists && doc.data()?['role'] == 'parent') {
        Get.find<PinService>().clearLocalPin();

        final pin = doc.data()?['pin'] as String?;
        if (pin != null && pin.isNotEmpty) {
          Get.find<PinService>().savePinLocalOnly(pin);
        }

        Get.find<PinService>().saveCredentials(email, pass);
        Get.offAllNamed('/parent-dashboard');
      } else {
        await _auth.signOut();
        emailError.value = 'Akun ini bukan akun Orang Tua';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emailError.value = 'Email Orang Tua tidak ditemukan';
        case 'wrong-password':
          passError.value = 'Kata sandi salah';
        case 'invalid-credential':
          passError.value = 'Email atau kata sandi salah';
        case 'invalid-email':
          emailError.value = 'Format email tidak valid';
        case 'too-many-requests':
          passError.value = 'Terlalu banyak percobaan. Coba lagi nanti';
        case 'user-disabled':
          emailError.value = 'Akun ini telah dinonaktifkan';
        default:
          serverError.value = 'Terjadi kesalahan. Coba lagi';
      }
    } catch (_) {
      serverError.value = 'Koneksi bermasalah. Cek internetmu';
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  Future<void> sendResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
