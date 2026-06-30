import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/child_progress_service.dart';

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
  // Urutan harus sama persis dengan PetualanganController._cycle
  static const _cycle = [
    QuestLevelDef('Suku Kata', Icons.extension_rounded,
        Color(0xFF2977C7), Color(0xFF1A5EA0), Routes.GAME_SUKUKATA),
    QuestLevelDef('Kosa Kata', Icons.menu_book_rounded,
        Color(0xFF4CAF50), Color(0xFF338A3E), Routes.GAME_KOSAKATA),
    QuestLevelDef('Rima', Icons.headphones_rounded,
        Color(0xFFE8621A), Color(0xFFBF4D10), Routes.GAME_RIMA),
    QuestLevelDef('Fonem', Icons.volume_up_rounded,
        Color(0xFF7C3AED), Color(0xFF5B21B6), Routes.GAME_FONEM),
  ];

  final isLoading = true.obs;
  // -1 = petualangan belum dimulai, >= 0 = index level hari ini
  final todayLevelIdx = (-1).obs;

  ChildProgressService get _svc => Get.find<ChildProgressService>();

  QuestLevelDef? get todayDef =>
      todayLevelIdx.value >= 0
          ? _cycle[todayLevelIdx.value % _cycle.length]
          : null;

  // True jika user sudah sempurnakan level hari ini
  bool get isTodayCompleted =>
      todayLevelIdx.value >= 0 &&
      _svc.petualanganCompleted.contains(todayLevelIdx.value);

  bool get isClaimedToday => _svc.isQuestClaimedToday;

  String get rankLabel {
    final lvl = _svc.level.value;
    if (lvl >= 20) return 'Gold';
    if (lvl >= 10) return 'Silver';
    return 'Bronze';
  }

  Color get rankColor {
    final lvl = _svc.level.value;
    if (lvl >= 20) return const Color(0xFFFFD700);
    if (lvl >= 10) return const Color(0xFF9E9E9E);
    return const Color(0xFFCD7F32);
  }

  String get rankEmoji {
    final lvl = _svc.level.value;
    if (lvl >= 20) return '🥇';
    if (lvl >= 10) return '🥈';
    return '🥉';
  }

  // Bonus XP dari quest: Bronze=3, Silver=7, Gold=10
  int get bonusXp {
    final lvl = _svc.level.value;
    if (lvl >= 20) return 10;
    if (lvl >= 10) return 7;
    return 3;
  }

  // Jumlah soal sesuai rank: Bronze=5, Silver=10, Gold=15
  int get questionCount {
    final lvl = _svc.level.value;
    if (lvl >= 20) return 15;
    if (lvl >= 10) return 10;
    return 5;
  }

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    isLoading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final startKey = doc.data()?['petualanganStartDate'] as String?;
        if (startKey != null) {
          final fromDate      = _daysSince06(startKey);
          final fromCompleted = _svc.petualanganCompleted.length;
          // Pakai nilai terbesar: kalau user sudah selesaikan lebih banyak
          // level daripada hari yang sudah berlalu (devMode atau catch-up),
          // quest mengikuti level yang sedang aktif di petualangan.
          todayLevelIdx.value = fromDate > fromCompleted ? fromDate : fromCompleted;
        }
      }
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> claimReward() async {
    if (isClaimedToday || !isTodayCompleted) return;
    await _svc.claimQuestReward(bonusXp);
  }

  // Hitung hari sejak tanggal mulai (batas jam 06:00)
  static int _daysSince06(String startKey) {
    final now = DateTime.now();
    final start = DateTime.parse(startKey);
    final firstUnlock =
        DateTime(start.year, start.month, start.day, 6, 0, 0);
    if (now.isBefore(firstUnlock)) return 0;
    return now.difference(firstUnlock).inDays;
  }
}
