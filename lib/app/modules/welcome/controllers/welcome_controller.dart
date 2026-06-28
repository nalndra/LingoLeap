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
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _auth.authStateChanges().first,
    ]);

    final user = results[1] as User?;

    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    if (!user.emailVerified) {
      Get.offAllNamed(Routes.VERIFY_EMAIL);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?['role'] == 'parent') {
        final pinService = Get.find<PinService>();
        if (pinService.hasPin.value) {
          Get.offAllNamed(Routes.PIN_LOGIN);
        } else {
          Get.offAllNamed(Routes.PARENT_DASHBOARD);
        }
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (_) {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
