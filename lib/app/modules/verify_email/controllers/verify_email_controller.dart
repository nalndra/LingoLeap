import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../../../services/pin_service.dart';

class VerifyEmailController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final isLoading = false.obs;
  final isEmailVerified = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startPolling();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _auth.currentUser?.reload();
      final verified = _auth.currentUser?.emailVerified ?? false;
      if (verified) {
        _timer?.cancel();
        isEmailVerified.value = true;
        await _navigateByRole();
      }
    });
  }

  Future<void> _navigateByRole() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .timeout(const Duration(seconds: 8));
        if (doc.data()?['role'] == 'parent') {
          final pinService = Get.find<PinService>();
          if (pinService.hasPin.value) {
            Get.offAllNamed(Routes.PIN_LOGIN);
          } else {
            Get.offAllNamed(Routes.PARENT_DASHBOARD);
          }
          return;
        }
      } catch (_) {}
    }
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> resendEmail() async {
    try {
      isLoading.value = true;
      await _auth.currentUser?.sendEmailVerification();
      Get.snackbar(
        'Email Dikirim',
        'Link verifikasi sudah dikirim ulang ke emailmu!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengirim ulang email. Coba lagi nanti.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void backToLogin() {
    _timer?.cancel();
    _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
