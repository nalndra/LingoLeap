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
      xp.value = data['xp'] ?? 0;
      level.value = data['level'] ?? 1;
      streak.value = data['streak'] ?? 0;
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

      debugPrint('[ChildProgressService] Stats loaded for ${_auth.currentUser?.uid}');
    } catch (e) {
      debugPrint('[ChildProgressService] loadChildStats error: $e');
    }
  }

  void clearStats() {
    childName.value = '';
    xp.value = 0;
    level.value = 1;
    streak.value = 0;
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
  }

  // ─── Save game result ─────────────────────────────────────────────────────

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

      // Award XP
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
      final data = {
        'xp': xp.value,
        'level': level.value,
        'streak': streak.value,
        'hearts': hearts.value,
        'gems': gems.value,
        'stats': {
          'sukuKata': sukuKataProgress.value,
          'fonem': fonemProgress.value,
          'kosakata': kosakataProgress.value,
          'rima': rimaProgress.value,
          'totalGamesPlayed': totalGamesPlayed.value,
          'totalCorrect': totalCorrect.value,
          'totalWrong': totalWrong.value,
        },
        'kataSulit': kataSulit.toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (gameName != null && finalIndex != null) {
        data['gameIndexes'] = {
          gameName: finalIndex,
        };
      }

      await doc.set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[ChildProgressService] _syncToFirestore error: $e');
    }
  }
}
