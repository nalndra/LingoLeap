import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final emailController           = TextEditingController();
  final nameController            = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  // Inline error strings
  final emailError   = ''.obs;
  final nameError    = ''.obs;
  final passError    = ''.obs;
  final confirmError = ''.obs;
  final serverError  = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailError.value.isNotEmpty) emailError.value = '';
      if (serverError.value.isNotEmpty) serverError.value = '';
    });
    nameController.addListener(() {
      if (nameError.value.isNotEmpty) nameError.value = '';
    });
    passwordController.addListener(() {
      if (passError.value.isNotEmpty) passError.value = '';
      // Re-validate konfirmasi jika sudah ada isi
      if (confirmError.value.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        if (passwordController.text == confirmPasswordController.text) {
          confirmError.value = '';
        }
      }
    });
    confirmPasswordController.addListener(() {
      if (confirmError.value.isNotEmpty) confirmError.value = '';
    });
  }

  @override
  void onClose() {
    Future.delayed(const Duration(milliseconds: 500), () {
      emailController.dispose();
      nameController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });
    super.onClose();
  }

  bool _validate() {
    bool ok = true;
    final email   = emailController.text.trim();
    final name    = nameController.text.trim();
    final pass    = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (email.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      ok = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Format email tidak valid';
      ok = false;
    }

    if (name.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      ok = false;
    } else if (name.length < 2) {
      nameError.value = 'Nama minimal 2 karakter';
      ok = false;
    }

    if (pass.isEmpty) {
      passError.value = 'Kunci rahasia tidak boleh kosong';
      ok = false;
    } else if (pass.length < 6) {
      passError.value = 'Kunci rahasia minimal 6 karakter';
      ok = false;
    }

    if (confirm.isEmpty) {
      confirmError.value = 'Konfirmasi kunci rahasia tidak boleh kosong';
      ok = false;
    } else if (pass != confirm) {
      confirmError.value = 'Kunci rahasia tidak cocok';
      ok = false;
    }

    return ok;
  }

  Future<void> register() async {
    serverError.value = '';
    if (!_validate()) return;

    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      final name  = nameController.text.trim();
      final pass  = passwordController.text;

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await cred.user?.updateDisplayName(name);

      try { await cred.user?.sendEmailVerification(); } catch (_) {}

      final uid = cred.user?.uid;
      if (uid != null) {
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

      Get.offAllNamed(Routes.VERIFY_EMAIL);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emailError.value = 'Email ini sudah digunakan';
        case 'invalid-email':
          emailError.value = 'Format email tidak valid';
        case 'weak-password':
          passError.value = 'Kunci rahasia terlalu lemah (min. 6 karakter)';
        case 'operation-not-allowed':
          serverError.value = 'Pendaftaran tidak diizinkan saat ini';
        default:
          serverError.value = 'Terjadi kesalahan. Coba lagi';
      }
    } catch (_) {
      serverError.value = 'Koneksi bermasalah. Cek internetmu';
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
