import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../../../services/child_progress_service.dart';

class LoginController extends GetxController {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  // Inline error strings — kosong = tidak ada error
  final emailError = ''.obs;
  final passError  = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailError.value.isNotEmpty) emailError.value = '';
    });
    passwordController.addListener(() {
      if (passError.value.isNotEmpty) passError.value = '';
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
      passError.value = 'Kunci rahasia tidak boleh kosong';
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
      );

      // Auto-migrate legacy accounts
      final uid  = cred.user?.uid;
      final name = cred.user?.displayName ?? 'Pahlawan';
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'name': name,
            'email': email,
            'role': 'child',
            'level': 1,
            'xp': 0,
            'parentId': null,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      if (cred.user != null && !cred.user!.emailVerified) {
        await cred.user!.sendEmailVerification();
        Get.offAllNamed(Routes.VERIFY_EMAIL);
        return;
      }

      try { await Get.find<ChildProgressService>().loadChildStats(); } catch (_) {}
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emailError.value = 'Email pahlawan tidak ditemukan';
        case 'wrong-password':
          passError.value = 'Kunci rahasia salah';
        case 'invalid-credential':
          passError.value = 'Email atau kunci rahasia salah';
        case 'invalid-email':
          emailError.value = 'Format email tidak valid';
        case 'too-many-requests':
          passError.value = 'Terlalu banyak percobaan. Coba lagi nanti';
        case 'user-disabled':
          emailError.value = 'Akun ini telah dinonaktifkan';
        default:
          passError.value = 'Terjadi kesalahan. Coba lagi';
      }
    } catch (_) {
      passError.value = 'Koneksi bermasalah. Cek internetmu';
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
