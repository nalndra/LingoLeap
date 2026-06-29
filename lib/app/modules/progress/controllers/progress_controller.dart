import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/child_progress_service.dart';
import '../../quest/controllers/quest_controller.dart';

class ProgressController extends GetxController {
  ChildProgressService get _svc => Get.find<ChildProgressService>();

  // ── Proxies reaktif ke service ──────────────────────────────────────────────
  RxInt get xp => _svc.xp;
  RxInt get level => _svc.level;
  RxString get childName => _svc.childName;

  // ── Rank ────────────────────────────────────────────────────────────────────
  String get rankLabel {
    if (level.value >= 20) return 'Emas';
    if (level.value >= 10) return 'Perak';
    return 'Perunggu';
  }

  String get rankEmoji {
    if (level.value >= 20) return '🥇';
    if (level.value >= 10) return '🥈';
    return '🥉';
  }

  Color get rankColor {
    if (level.value >= 20) return const Color(0xFFDAA520);
    if (level.value >= 10) return const Color(0xFF78909C);
    return const Color(0xFFCD7F32);
  }

  Color get rankBgColor {
    if (level.value >= 20) return const Color(0xFFFFF8E1);
    if (level.value >= 10) return const Color(0xFFECEFF1);
    return const Color(0xFFFBEEE3);
  }

  // Cap XP sesuai rank: Bronze=150, Silver/Gold=300
  int get rankCap => level.value >= 10 ? 300 : 150;

  // Progress bar value: clamp 0-1, Gold boleh overflow di teks
  double get levelBarValue => (xp.value / rankCap).clamp(0.0, 1.0);

  // ── Statistik (logika sama dengan parent_dashboard) ─────────────────────────
  int get fokus {
    final c = _svc.totalCorrect.value;
    final w = _svc.totalWrong.value;
    final t = c + w;
    return t > 0 ? ((c / t) * 100).toInt() : 0;
  }

  int get kecepatanMembaca =>
      ((_svc.rimaProgress.value + _svc.sukuKataProgress.value) / 2).toInt();

  int get pengenalanHuruf => _svc.fonemProgress.value;

  // ── Quest journey (sinkron dengan QuestController) ──────────────────────────
  // Index dalam siklus 4 game (0-3), -1 jika petualangan belum dimulai
  int get todayQuestCycleIdx {
    try {
      final idx = Get.find<QuestController>().todayLevelIdx.value;
      return idx >= 0 ? idx % 4 : -1;
    } catch (_) {
      return -1;
    }
  }

  bool get isTodayQuestDone {
    try {
      return Get.find<QuestController>().isTodayCompleted;
    } catch (_) {
      return false;
    }
  }
}
