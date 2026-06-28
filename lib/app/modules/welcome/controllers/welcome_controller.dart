import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../../../services/pin_service.dart';

class WelcomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    // Auto navigate ke login atau home setelah 3 detik
    Timer(const Duration(seconds: 3), () async {
      final user = _auth.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists && doc.data()?['role'] == 'parent') {
            final pinService = Get.find<PinService>();
            if (pinService.hasPin.value) {
              Get.offAllNamed('/pin-login');
            } else {
              Get.offAllNamed('/parent-dashboard');
            }
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } catch (e) {
          Get.offAllNamed(Routes.HOME);
        }
      }
    });
  }
}
