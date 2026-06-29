import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Central service that tracks and persists child game performance to Firestore.
/// Parent dashboard listens to the same Firestore documents for real-time updates.
class ChildProgressService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Observable stats (loaded from Firestore on init) ───
  final xp = 0.obs;
  final level = 1.obs;
  final streak = 0.obs;
  final hearts = 5.obs;
  final gems = 50.obs;

  // Per-game progress percentages
  final childName = ''.obs;
  final photoUrl  = ''.obs;

  final sukuKataProgress = 0.obs;
  final fonemProgress = 0.obs;
  final kosakataProgress = 0.obs;
  final rimaProgress = 0.obs;

  // Game resume indexes
  final sukuKataIndex = 0.obs;
  final fonemIndex = 0.obs;
  final kosakataIndex = 0.obs;
  final rimaIndex = 0.obs;

  // Aggregate counters
  final totalGamesPlayed = 0.obs;
  final totalCorrect = 0.obs;
  final totalWrong = 0.obs;

  // Difficult words
  final kataSulit = <Map<String, dynamic>>[].obs;

  // ─── Streak tracking ──────────────────────────────────────────────────────
  // Format YYYY-MM-DD, boundary tengah malam (00:00)
  final streakLastDate = ''.obs;

  // ─── Adventure / quest tracking ───────────────────────────────────────────
  // questCompletedLevel >= 0 → quest done, reward belum diambil
  final questCompletedLevel = (-1).obs;
  // Level petualangan yang sudah memberikan XP (tidak bisa dapat lagi)
  final adventureXpClaimed = <int>[].obs;
  // Levels yang sudah diselesaikan dengan sempurna di mode petualangan
  final petualanganCompleted = <int>[].obs;
  // Tanggal terakhir quest diklaim (format YYYY-MM-DD, pakai _todayResetKey)
  final questClaimedDate = ''.obs;

  bool get isQuestClaimedToday => questClaimedDate.value == _todayResetKey();

  /// Returns the Firestore document reference for the current child user.
  DocumentReference? get _userDoc {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  // ─── Load stats from Firestore ────────────────────────────────────────────

  /// Call this after child login to hydrate local observables from Firestore.
  Future<void> loadChildStats() async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      final snap = await doc.get();
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>? ?? {};

      childName.value = data['name'] ?? _auth.currentUser?.displayName ?? 'Pahlawan';
      photoUrl.value  = data['photoUrl'] as String? ?? _auth.currentUser?.photoURL ?? '';
      xp.value = data['xp'] ?? 0;
      level.value = data['level'] ?? 1;
      streak.value = (data['streak'] as num?)?.toInt() ?? 0;
      streakLastDate.value = data['streakLastDate'] as String? ?? '';
      hearts.value = data['hearts'] ?? 5;
      gems.value = data['gems'] ?? 50;

      if (data.containsKey('stats')) {
        final stats = data['stats'] as Map<String, dynamic>;
        sukuKataProgress.value = (stats['sukuKata'] as num?)?.toInt() ?? 0;
        fonemProgress.value = (stats['fonem'] as num?)?.toInt() ?? 0;
        kosakataProgress.value = (stats['kosakata'] as num?)?.toInt() ?? 0;
        rimaProgress.value = (stats['rima'] as num?)?.toInt() ?? 0;
        totalGamesPlayed.value = (stats['totalGamesPlayed'] as num?)?.toInt() ?? 0;
        totalCorrect.value = (stats['totalCorrect'] as num?)?.toInt() ?? 0;
        totalWrong.value = (stats['totalWrong'] as num?)?.toInt() ?? 0;
      }

      if (data.containsKey('gameIndexes')) {
        final gameIndexes = data['gameIndexes'] as Map<String, dynamic>;
        sukuKataIndex.value = gameIndexes['sukuKata'] ?? 0;
        fonemIndex.value = gameIndexes['fonem'] ?? 0;
        kosakataIndex.value = gameIndexes['kosakata'] ?? 0;
        rimaIndex.value = gameIndexes['rima'] ?? 0;
      }

      if (data.containsKey('kataSulit')) {
        kataSulit.value =
            List<Map<String, dynamic>>.from(data['kataSulit'] ?? []);
      }

      // Adventure / quest
      questCompletedLevel.value = (data['questCompletedLevel'] as int?) ?? -1;
      final xpClaimed = data['adventureXpClaimed'] as List?;
      if (xpClaimed != null) {
        adventureXpClaimed.assignAll(xpClaimed.whereType<int>());
      }
      questClaimedDate.value = data['questClaimedDate'] as String? ?? '';
      final pComplete = data['petualanganCompleted'] as List?;
      if (pComplete != null) {
        petualanganCompleted.assignAll(pComplete.whereType<int>());
      }

      // Daily heart reset — reset ke 5 tiap hari di batas 06:00
      final resetKey = _todayResetKey();
      final lastReset = data['lastHeartResetDate'] as String?;
      if (lastReset != resetKey) {
        hearts.value = 5;
        await doc.set(
          {'hearts': 5, 'lastHeartResetDate': resetKey},
          SetOptions(merge: true),
        );
        debugPrint('[ChildProgressService] Hearts reset for window $resetKey');
      }

      debugPrint('[ChildProgressService] Stats loaded for ${_auth.currentUser?.uid}');
    } catch (e) {
      debugPrint('[ChildProgressService] loadChildStats error: $e');
    }

    // Update streak setelah data dimuat
    await _updateStreakOnLogin();
  }

  void clearStats() {
    childName.value = '';
    photoUrl.value  = '';
    xp.value = 0;
    level.value = 1;
    streak.value = 0;
    streakLastDate.value = '';
    hearts.value = 5;
    gems.value = 50;

    sukuKataProgress.value = 0;
    fonemProgress.value = 0;
    kosakataProgress.value = 0;
    rimaProgress.value = 0;

    sukuKataIndex.value = 0;
    fonemIndex.value = 0;
    kosakataIndex.value = 0;
    rimaIndex.value = 0;

    totalGamesPlayed.value = 0;
    totalCorrect.value = 0;
    totalWrong.value = 0;
    kataSulit.clear();

    questCompletedLevel.value = -1;
    adventureXpClaimed.clear();
    petualanganCompleted.clear();
    questClaimedDate.value = '';
  }

  // ─── Heart / XP convenience methods ──────────────────────────────────────

  /// Kurangi 1 heart (min 0). Dipanggil saat jawaban salah di adventure mode.
  Future<void> loseHeart() async {
    hearts.value = (hearts.value - 1).clamp(0, 5);
    await syncBasicStats(newHearts: hearts.value);
  }

  /// Tambah 1 heart (max 5). Dipanggil saat klaim reward quest.
  Future<void> gainHeart() async {
    hearts.value = (hearts.value + 1).clamp(0, 5);
    await syncBasicStats(newHearts: hearts.value);
  }

  /// Tambah XP dan update level. Dipanggil setelah sesi adventure selesai.
  Future<void> gainXP(int amount) async {
    if (amount <= 0) return;
    xp.value += amount;
    level.value = 1 + (xp.value ~/ 100);
    await syncBasicStats(newXp: xp.value, newLevel: level.value);
  }

  // ─── Streak methods ────────────────────────────────────────────────────────

  /// Dipanggil otomatis di akhir loadChildStats().
  /// Boundary tengah malam (00:00). Grace period 2 hari: jika absen 1 hari
  /// user masih bisa +1, absen 2+ hari streak direset ke 1.
  Future<void> _updateStreakOnLogin() async {
    if (_userDoc == null) return;
    final today = _todayStreakKey();
    final last = streakLastDate.value;

    if (last == today) return; // sudah tercatat hari ini

    final int newStreak;
    if (last.isEmpty) {
      newStreak = 1;
    } else {
      final diff = _daysBetween(last, today);
      if (diff <= 2) {
        // diff==1: berurutan; diff==2: grace period (absen 1 hari, masih selamat)
        newStreak = streak.value + 1;
      } else {
        // absen 2 hari atau lebih → reset
        newStreak = 1;
      }
    }

    streak.value = newStreak;
    streakLastDate.value = today;

    try {
      await _userDoc!.set(
        {'streak': newStreak, 'streakLastDate': today},
        SetOptions(merge: true),
      );
      debugPrint('[ChildProgressService] Streak updated → $newStreak (last: $last, today: $today)');
    } catch (e) {
      debugPrint('[ChildProgressService] _updateStreakOnLogin error: $e');
    }
  }

  // Tanggal hari ini berdasarkan tengah malam (00:00)
  static String _todayStreakKey() {
    final now = DateTime.now();
    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // Selisih hari antara dua string YYYY-MM-DD
  static int _daysBetween(String from, String to) {
    final a = DateTime.parse(from);
    final b = DateTime.parse(to);
    return b.difference(a).inDays;
  }

  // ─── Quest methods ─────────────────────────────────────────────────────────

  /// Dipanggil oleh PetualanganController saat level diselesaikan dengan sempurna.
  Future<void> markQuestCompleted(int levelIdx) async {
    if (!petualanganCompleted.contains(levelIdx)) {
      petualanganCompleted.add(levelIdx);
    }
    if (questCompletedLevel.value >= 0) return;
    questCompletedLevel.value = levelIdx;
    await _syncQuestState();
  }

  /// Klaim reward quest: +1 heart + bonusXP. Reset quest state.
  Future<void> claimQuestReward(int bonusXP) async {
    if (isQuestClaimedToday) return;
    questClaimedDate.value = _todayResetKey();
    questCompletedLevel.value = -1;
    await _syncQuestState();
    await gainHeart();
    await gainXP(bonusXP);
  }

  // ─── Daily reset key (batas 06:00) ──────────────────────────────────────────
  // Sebelum jam 06:00 dianggap masih "hari kemarin".
  static String _todayResetKey() {
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day, 6);
    final effective = now.isBefore(cutoff)
        ? now.subtract(const Duration(days: 1))
        : now;
    return '${effective.year}-'
        '${effective.month.toString().padLeft(2, '0')}-'
        '${effective.day.toString().padLeft(2, '0')}';
  }

  Future<void> _syncQuestState() async {
    final doc = _userDoc;
    if (doc == null) return;
    try {
      await doc.set(
        {
          'questCompletedLevel': questCompletedLevel.value,
          'questClaimedDate': questClaimedDate.value,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('[ChildProgressService] _syncQuestState error: $e');
    }
  }

  // ─── XP claimed tracking ──────────────────────────────────────────────────

  /// Catat bahwa level [levelIdx] sudah memberikan XP (tidak bisa dapat lagi).
  Future<void> markXpClaimed(int levelIdx) async {
    if (adventureXpClaimed.contains(levelIdx)) return;
    adventureXpClaimed.add(levelIdx);
    await _syncXpClaimed();
  }

  Future<void> _syncXpClaimed() async {
    final doc = _userDoc;
    if (doc == null) return;
    try {
      await doc.set(
        {'adventureXpClaimed': adventureXpClaimed.toList()},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('[ChildProgressService] _syncXpClaimed error: $e');
    }
  }

  // ─── Save game result (normal mode only) ─────────────────────────────────

  /// Called by each game controller after the child finishes a game session.
  ///
  /// [gameName] — one of: 'sukuKata', 'fonem', 'kosakata', 'rima'
  /// [sessionCorrectCount] — number of questions answered correctly in this session
  /// [totalGameQuestions] — total number of questions in the entire game (for % progress)
  /// [sessionPlayedCount] — number of questions played in this session
  /// [wrongWords] — list of words the child got wrong (for kataSulit tracking)
  /// [lastIndex] — the index of the last question the user saw (for resuming)
  Future<void> saveGameResult({
    required String gameName,
    required int sessionCorrectCount,
    required int totalGameQuestions,
    required int sessionPlayedCount,
    required int lastIndex,
    List<String> wrongWords = const [],
  }) async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      // Update local counters
      totalGamesPlayed.value++;
      totalCorrect.value += sessionCorrectCount;
      totalWrong.value += (sessionPlayedCount - sessionCorrectCount);

      // Hitung persentase progress absolut berdasarkan seberapa jauh (index) anak bermain
      final progressPercent =
          totalGameQuestions > 0 ? (((lastIndex + 1) / totalGameQuestions) * 100).round() : 0;

      // Update per-game progress (simpan nilai tertinggi agar progress tidak turun)
      switch (gameName) {
        case 'sukuKata':
          sukuKataProgress.value = max(sukuKataProgress.value, progressPercent);
          break;
        case 'fonem':
          fonemProgress.value = max(fonemProgress.value, progressPercent);
          break;
        case 'kosakata':
          kosakataProgress.value = max(kosakataProgress.value, progressPercent);
          break;
        case 'rima':
          rimaProgress.value = max(rimaProgress.value, progressPercent);
          break;
      }

      // Update resume index
      int finalIndex = lastIndex;
      if (finalIndex >= totalGameQuestions - 1) {
        finalIndex = 0; // Reset if finished the whole game
      }

      switch (gameName) {
        case 'sukuKata':
          sukuKataIndex.value = finalIndex;
          break;
        case 'fonem':
          fonemIndex.value = finalIndex;
          break;
        case 'kosakata':
          kosakataIndex.value = finalIndex;
          break;
        case 'rima':
          rimaIndex.value = finalIndex;
          break;
      }

      // Update kata sulit
      for (final word in wrongWords) {
        _incrementKataSulit(word);
      }

      // Award XP (normal mode: 5 per correct)
      final earnedXp = sessionCorrectCount * 5;
      xp.value += earnedXp;

      // Level up every 100 XP
      level.value = 1 + (xp.value ~/ 100);

      // Persist everything to Firestore
      await _syncToFirestore(gameName: gameName, finalIndex: finalIndex);

      debugPrint('[ChildProgressService] Game "$gameName" saved: $sessionCorrectCount/$sessionPlayedCount correct. Progress: $progressPercent%');
    } catch (e) {
      debugPrint('[ChildProgressService] saveGameResult error: $e');
    }
  }


  /// Increment or add a word to the kata sulit list.
  void _incrementKataSulit(String word) {
    final normalized = word.trim();
    if (normalized.isEmpty) return;

    final idx = kataSulit.indexWhere(
      (m) => (m['word'] as String).toLowerCase() == normalized.toLowerCase(),
    );

    if (idx != -1) {
      kataSulit[idx] = {
        'word': kataSulit[idx]['word'],
        'count': (kataSulit[idx]['count'] as int) + 1,
      };
    } else {
      kataSulit.add({'word': normalized, 'count': 1});
    }

    // Keep only top 20 most difficult words, sorted by count descending
    kataSulit.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    if (kataSulit.length > 20) {
      kataSulit.removeRange(20, kataSulit.length);
    }
  }

  // ─── Sync basic stats (hearts, gems, xp changes from home_controller) ────

  /// Call this whenever hearts/gems/xp/streak change outside of game sessions
  /// (e.g. shop purchases, streak updates).
  Future<void> syncBasicStats({
    int? newXp,
    int? newLevel,
    int? newHearts,
    int? newGems,
    int? newStreak,
  }) async {
    if (newXp != null) xp.value = newXp;
    if (newLevel != null) level.value = newLevel;
    if (newHearts != null) hearts.value = newHearts;
    if (newGems != null) gems.value = newGems;
    if (newStreak != null) streak.value = newStreak;
    await _syncToFirestore();
  }

  // ─── Firestore write ──────────────────────────────────────────────────────

  Future<void> _syncToFirestore({String? gameName, int? finalIndex}) async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      // Pastikan finalIndex dari sesi ini tercermin di observable sebelum nulis
      if (gameName != null && finalIndex != null) {
        switch (gameName) {
          case 'sukuKata':  sukuKataIndex.value  = finalIndex; break;
          case 'fonem':     fonemIndex.value      = finalIndex; break;
          case 'kosakata':  kosakataIndex.value   = finalIndex; break;
          case 'rima':      rimaIndex.value       = finalIndex; break;
        }
      }

      final data = <String, dynamic>{
        'xp': xp.value,
        'level': level.value,
        'streak': streak.value,
        'streakLastDate': streakLastDate.value,
        'hearts': hearts.value,
        'gems': gems.value,
        'questCompletedLevel': questCompletedLevel.value,
        'questClaimedDate': questClaimedDate.value,
        'adventureXpClaimed': adventureXpClaimed.toList(),
        'stats': {
          'sukuKata': sukuKataProgress.value,
          'fonem': fonemProgress.value,
          'kosakata': kosakataProgress.value,
          'rima': rimaProgress.value,
          'totalGamesPlayed': totalGamesPlayed.value,
          'totalCorrect': totalCorrect.value,
          'totalWrong': totalWrong.value,
        },
        // Semua game indexes disimpan setiap write agar tidak ada yang hilang
        'gameIndexes': {
          'sukuKata': sukuKataIndex.value,
          'fonem':    fonemIndex.value,
          'kosakata': kosakataIndex.value,
          'rima':     rimaIndex.value,
        },
        'kataSulit': kataSulit.toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      await doc.set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[ChildProgressService] _syncToFirestore error: $e');
    }
  }
}
