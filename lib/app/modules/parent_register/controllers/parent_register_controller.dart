import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentRegisterController extends GetxController {
  final emailController           = TextEditingController();
  final nameController            = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading              = false.obs;
  final obscurePassword        = true.obs;
  final obscureConfirmPassword = true.obs;

  // Inline error strings
  final emailError   = ''.obs;
  final nameError    = ''.obs;
  final passError    = ''.obs;
  final confirmError = ''.obs;
  final serverError  = ''.obs;

  final FirebaseAuth      _auth      = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleObscurePassword()        => obscurePassword.value = !obscurePassword.value;
  void toggleObscureConfirmPassword() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

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
      if (confirmError.value.isNotEmpty &&
          confirmPasswordController.text == passwordController.text) {
        confirmError.value = '';
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
      passError.value = 'Kata sandi tidak boleh kosong';
      ok = false;
    } else if (pass.length < 6) {
      passError.value = 'Kata sandi minimal 6 karakter';
      ok = false;
    }

    if (confirm.isEmpty) {
      confirmError.value = 'Konfirmasi kata sandi tidak boleh kosong';
      ok = false;
    } else if (pass != confirm) {
      confirmError.value = 'Kata sandi tidak cocok';
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
      ).timeout(const Duration(seconds: 15));

      await cred.user?.updateDisplayName(name);

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'name': name,
        'role': 'parent',
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));

      Get.offNamed('/parent-login');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emailError.value = 'Email ini sudah digunakan';
        case 'invalid-email':
          emailError.value = 'Format email tidak valid';
        case 'weak-password':
          passError.value = 'Kata sandi terlalu lemah (min. 6 karakter)';
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
