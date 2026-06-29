import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/child_progress_service.dart';

class PetLevel {
  final String name;
  final IconData icon;
  final Color color;
  final Color darkColor;
  final String route;
  const PetLevel(
      this.name, this.icon, this.color, this.darkColor, this.route);
}

class PetualanganController extends GetxController {
  // ── Matikan untuk production, nyalakan saat developing ──────────────────────
  static const devMode = true;

  // Urutan: day 1 = suku kata, day 2 = kosa kata, day 3 = rima, day 4 = fonem
  static const _cycle = [
    PetLevel('Suku Kata', Icons.extension_rounded,
        Color(0xFF2977C7), Color(0xFF1A5EA0), Routes.GAME_SUKUKATA),
    PetLevel('Kosa Kata', Icons.menu_book_rounded,
        Color(0xFF4CAF50), Color(0xFF338A3E), Routes.GAME_KOSAKATA),
    PetLevel('Rima',      Icons.headphones_rounded,
        Color(0xFFE8621A), Color(0xFFBF4D10), Routes.GAME_RIMA),
    PetLevel('Fonem',     Icons.volume_up_rounded,
        Color(0xFF7C3AED), Color(0xFF5B21B6), Routes.GAME_FONEM),
  ];

  final isLoading        = true.obs;
  final tutorialCompleted = false.obs;
  final unlockedCount    = 0.obs;
  final completedLevels  = <int>[].obs;
  final playerName       = ''.obs;

  PetLevel defAt(int idx) => _cycle[idx % _cycle.length];

  bool isUnlocked(int idx) => idx < unlockedCount.value;
  bool isCompleted(int idx) => completedLevels.contains(idx);

  // ── Rank helpers ────────────────────────────────────────────────────────────
  // Bronze: level < 10 | Silver: 10–19 | Gold: >=20

  int get _questionCount {
    try {
      final lvl = Get.find<ChildProgressService>().level.value;
      if (lvl >= 20) return 15; // Gold
      if (lvl >= 10) return 10; // Silver
    } catch (_) {}
    return 5; // Bronze
  }

  int get _maxXp {
    try {
      final lvl = Get.find<ChildProgressService>().level.value;
      if (lvl >= 10) return 10; // Silver + Gold
    } catch (_) {}
    return 5; // Bronze
  }

  int get _questBonusXp {
    try {
      final lvl = Get.find<ChildProgressService>().level.value;
      if (lvl >= 20) return 10; // Gold
      if (lvl >= 10) return 7;  // Silver
    } catch (_) {}
    return 3; // Bronze
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final data = doc.data() ?? {};

        playerName.value = FirebaseAuth.instance.currentUser?.displayName
            ?? data['name'] as String?
            ?? 'Petualang';
        tutorialCompleted.value =
            data['tutorialCompleted'] as bool? ?? false;

        // Selalu load completed levels agar progress tidak hilang
        final raw = data['petualanganCompleted'] as List?;
        if (raw != null) {
          completedLevels.assignAll(raw.whereType<int>());
        }

        // Selalu pastikan startDate tercatat (dibutuhkan oleh sistem quest)
        String? startKey = data['petualanganStartDate'] as String?;
        if (startKey == null) {
          startKey = _dateKey(DateTime.now());
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set({'petualanganStartDate': startKey},
                  SetOptions(merge: true));
        }

        if (devMode) {
          unlockedCount.value = 9999;
        } else {
          unlockedCount.value = _daysSince06(startKey) + 1;
        }
      }
    } catch (_) {}
    isLoading.value = false;
  }

  // Navigasi ke tutorial, lalu refresh status setelah kembali
  Future<void> playTutorial() async {
    await Get.toNamed(Routes.TUTORIAL);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      tutorialCompleted.value =
          doc.data()?['tutorialCompleted'] as bool? ?? false;
    } catch (_) {}
  }

  Future<void> playLevel(int levelIdx) async {
    if (!isUnlocked(levelIdx)) return;
    final def = defAt(levelIdx);
    final svc = Get.find<ChildProgressService>();
    final alreadyClaimed = svc.adventureXpClaimed.contains(levelIdx);

    final result = await Get.toNamed(
      def.route,
      arguments: {
        'adventureMode': true,
        'questionCount': _questionCount,
      },
    );

    if (result is Map) {
      final correct = (result['correct'] as int?) ?? 0;
      final total   = (result['total']   as int?) ?? 0;
      final perfect = total > 0 && correct == total;

      // Award XP hanya di percobaan pertama (per level)
      if (!alreadyClaimed && total > 0) {
        final earned = (correct / total * _maxXp).round();
        if (earned > 0) await svc.gainXP(earned);
        await svc.markXpClaimed(levelIdx);
      }

      // Kalau semua benar: tandai level selesai dan trigger quest
      if (perfect && !isCompleted(levelIdx)) {
        completedLevels.add(levelIdx);
        _saveCompleted();
        await svc.markQuestCompleted(levelIdx);
      }
    }
  }

  /// Klaim reward quest dari QuestView.
  Future<void> claimQuestReward() async {
    try {
      await Get.find<ChildProgressService>().claimQuestReward(_questBonusXp);
    } catch (_) {}
  }

  Future<void> _saveCompleted() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'petualanganCompleted': completedLevels.toList()},
              SetOptions(merge: true));
    } catch (_) {}
  }

  // ── Hitung hari (batas 06:00) sejak tanggal mulai ──────────────────────────
  static int _daysSince06(String startKey) {
    final now   = DateTime.now();
    final start = DateTime.parse(startKey);
    final firstUnlock =
        DateTime(start.year, start.month, start.day, 6, 0, 0);
    if (now.isBefore(firstUnlock)) return 0;
    return now.difference(firstUnlock).inDays;
  }

  static String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}'
      '-${dt.day.toString().padLeft(2, '0')}';
}
