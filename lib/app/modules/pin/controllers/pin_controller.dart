import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/pin_service.dart';

class PinController extends GetxController {
  final PinService _pinService = Get.find<PinService>();
  
  // State for PIN input
  final RxString currentInput = ''.obs;
  
  // For setup flow
  final RxString setupPin = ''.obs;

  void addDigit(String digit) {
    if (currentInput.value.length < 4) {
      currentInput.value += digit;
      if (currentInput.value.length == 4) {
        _onPinComplete();
      }
    }
  }

  void removeDigit() {
    if (currentInput.value.isNotEmpty) {
      currentInput.value = currentInput.value.substring(0, currentInput.value.length - 1);
    }
  }

  void _onPinComplete() {
    final route = Get.currentRoute;
    if (route == '/pin-setup') {
      setupPin.value = currentInput.value;
      currentInput.value = '';
      Get.toNamed('/pin-confirm');
    } else if (route == '/pin-confirm') {
      if (currentInput.value == setupPin.value) {
        _pinService.savePin(currentInput.value);
        Get.snackbar(
          'Berhasil',
          'PIN Orang Tua berhasil dibuat',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/parent-dashboard');
      } else {
        Get.snackbar(
          'Error',
          'PIN tidak cocok. Silakan coba lagi.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        currentInput.value = '';
      }
    } else if (route == '/pin-login') {
      if (_pinService.verifyPin(currentInput.value)) {
        Get.offAllNamed('/parent-dashboard');
      } else {
        Get.snackbar(
          'Error',
          'PIN salah. Silakan coba lagi.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        currentInput.value = '';
      }
    }
  }

  void onForgotPin() {
    // Navigate back to normal parent login and clear pin session
    _pinService.removePin();
    Get.offAllNamed('/parent-login');
  }
}
