import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

enum TutorialStep {
  welcome,
  introFonem, congratsFonem,
  introRima,  congratsRima,
  introSu,    congratsSu,
  introKo,    congratsKo,
}

class TutorialController extends GetxController {
  final stepIdx = 0.obs;
  TutorialStep get step => TutorialStep.values[stepIdx.value];
  double get overallProgress => stepIdx.value / (TutorialStep.values.length - 1);

  void nextStep() {
    switch (step) {
      case TutorialStep.welcome:
        stepIdx.value++;

      case TutorialStep.introFonem:
        _launchGame(Routes.GAME_FONEM);

      case TutorialStep.congratsFonem:
        stepIdx.value++;

      case TutorialStep.introRima:
        _launchGame(Routes.GAME_RIMA);

      case TutorialStep.congratsRima:
        stepIdx.value++;

      case TutorialStep.introSu:
        _launchGame(Routes.GAME_KOSAKATA);

      case TutorialStep.congratsSu:
        stepIdx.value++;

      case TutorialStep.introKo:
        _launchGame(Routes.GAME_SUKUKATA);

      case TutorialStep.congratsKo:
        // Game terakhir selesai — simpan ke Firestore lalu langsung balik ke home
        _markCompleted().whenComplete(Get.back);
    }
  }

  Future<void> _markCompleted() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'tutorialCompleted': true}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _launchGame(String route) async {
    final result = await Get.toNamed(
      route,
      arguments: {'tutorialMode': true},
    );
    // Advance ke congrats hanya kalau game benar-benar selesai
    if (result == true) stepIdx.value++;
  }

  // Tidak ada goBack — back button dihilangkan dari tutorial view
}
