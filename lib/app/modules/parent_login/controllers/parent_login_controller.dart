import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/pin_service.dart';

class ParentLoginController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController(); // Name field present in screenshot
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua kolom wajib diisi!', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));

      // Verify role
      final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get().timeout(const Duration(seconds: 10));
      if (doc.exists && doc.data()?['role'] == 'parent') {
        // Clear any old PIN session from a previous user
        Get.find<PinService>().clearLocalPin();

        // Sync PIN from database to local if it exists
        final pin = doc.data()?['pin'] as String?;
        if (pin != null && pin.isNotEmpty) {
          Get.find<PinService>().savePinLocalOnly(pin);
        }
        
        // Save credentials for PIN re-authentication
        Get.find<PinService>().saveCredentials(email, password);

        Get.snackbar('Sukses', 'Berhasil masuk sebagai Orang Tua!', backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/parent-dashboard');
      } else {
        await _auth.signOut();
        Get.snackbar('Gagal', 'Akun ini bukan akun Orang Tua.', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Gagal', e.message ?? 'Email atau password salah.', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal login: $e', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }
}
