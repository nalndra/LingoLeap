import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class QuestLevelDef {
  final String name;
  final IconData icon;
  final Color color;
  final Color darkColor;
  final String route;
  const QuestLevelDef(
      this.name, this.icon, this.color, this.darkColor, this.route);
}

class QuestController extends GetxController {
  static const _cycle = [
    QuestLevelDef('Kosakata', Icons.menu_book_rounded,
        Color(0xFF4CAF50), Color(0xFF338A3E), Routes.GAME_KOSAKATA),
    QuestLevelDef('Susun Huruf', Icons.extension_rounded,
        Color(0xFF2977C7), Color(0xFF1A5EA0), Routes.GAME_SUKUKATA),
    QuestLevelDef('Fonem', Icons.volume_up_rounded,
        Color(0xFF7C3AED), Color(0xFF5B21B6), Routes.GAME_FONEM),
    QuestLevelDef('Rima', Icons.headphones_rounded,
        Color(0xFFE8621A), Color(0xFFBF4D10), Routes.GAME_RIMA),
  ];

  final currentLevel = 0.obs;
  final isLoading = true.obs;

  QuestLevelDef defAt(int levelIdx) => _cycle[levelIdx % _cycle.length];

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        currentLevel.value = (doc.data()?['adventureLevel'] as int?) ?? 0;
      }
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> playLevel(int levelIdx) async {
    if (levelIdx > currentLevel.value) return;
    final def = defAt(levelIdx);
    final result = await Get.toNamed(
      def.route,
      arguments: {'adventureMode': true},
    );
    if (result == true && levelIdx == currentLevel.value) {
      currentLevel.value++;
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'adventureLevel': currentLevel.value}, SetOptions(merge: true));
    } catch (_) {}
  }
}
