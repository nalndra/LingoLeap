import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/child_progress_service.dart';
import '../../../services/feedback_service.dart';
import 'package:google_fonts/google_fonts.dart';

class _LetterQuestion {
  final String word;
  const _LetterQuestion(this.word);
  List<String> get letters => word.split('');
}

class GameSukukataController extends GetxController {
  // Each index gets a consistent color (tile 0 = green, tile 1 = yellow, etc.)
  static const tileMainColors = [
    Color(0xFF4CAF50), // green
    Color(0xFFE8A020), // yellow
    Color(0xFF2977C7), // blue
    Color(0xFFE8621A), // orange
    Color(0xFF7C3AED), // purple
    Color(0xFF00ACC1), // cyan
  ];

  static const tileDarkColors = [
    Color(0xFF338A3E),
    Color(0xFFB87A10),
    Color(0xFF1A5EA0),
    Color(0xFFBF4D10),
    Color(0xFF5B21B6),
    Color(0xFF00838F),
  ];

  // Kata-kata dipilih agar tidak ambigu (huruf-hurufnya tidak bisa membentuk kata lain yang umum)
  // Dihapus: IBU→UBI, API→IPA, GULA→LAGU, RUMAH→MARAH
  static const _questions = [
    // ── 3 huruf ──────────────────────────────────────────────────────────────
    _LetterQuestion('AJI'),
    _LetterQuestion('DOA'),

    // ── 4 huruf ──────────────────────────────────────────────────────────────
    _LetterQuestion('BOLA'),
    _LetterQuestion('MEJA'),
    _LetterQuestion('BAJU'),
    _LetterQuestion('TOPI'),
    _LetterQuestion('SAPI'),
    _LetterQuestion('DURI'),   // ULAR diganti: ULAR↔ALUR ambigu
    _LetterQuestion('BUDI'),
    _LetterQuestion('MADU'),   // MATA diganti: MATA↔AMAT ambigu
    _LetterQuestion('JARI'),
    _LetterQuestion('KADO'),   // ROTI diganti: ROTI↔TRIO ambigu
    _LetterQuestion('KOPI'),
    _LetterQuestion('TAHU'),
    _LetterQuestion('PAGI'),

    // ── 5 huruf ──────────────────────────────────────────────────────────────
    _LetterQuestion('PINTU'),
    _LetterQuestion('BUNGA'),
    _LetterQuestion('TEMAN'),
    _LetterQuestion('PISAU'),
    _LetterQuestion('KEBUN'),
    _LetterQuestion('DAPUR'),
    _LetterQuestion('BAMBU'),

    // ── 6 huruf ──────────────────────────────────────────────────────────────
    _LetterQuestion('PISANG'),   // KARUNG diganti: KARUNG↔KURANG ambigu
    _LetterQuestion('GARUDA'),
    _LetterQuestion('KUCING'),   // MANGGA diganti: MANGGA↔GAMANG ambigu
  ];

  late final RxInt currentIndex;
  int _correctCount = 0;
  int _sessionPlayedCount = 0;
  final List<String> _wrongWords = [];
  bool _isSaved = false;

  final shuffledTileIndices = <int>[].obs;
  final slotTileIndex = <int>[].obs;
  final tileUsed = <bool>[].obs;

  bool _tutorialMode = false;
  bool _adventureMode = false;
  List<_LetterQuestion> _active = [];

  List<String> get letters => _active[currentIndex.value].letters;
  String get word => _active[currentIndex.value].word;
  int get totalQuestions => _active.length;
  double get progress => (currentIndex.value + 1) / _active.length;
  bool get adventureMode => _adventureMode;

  @override
  void onInit() {
    super.onInit();
    _tutorialMode = Get.arguments?['tutorialMode'] == true;
    _adventureMode = Get.arguments?['adventureMode'] == true;
    if (_tutorialMode) {
      final pool = _questions.where((q) => q.word.length == 4).toList()
        ..shuffle(Random());
      _active = pool.take(2).toList();
      currentIndex = 0.obs;
    } else if (_adventureMode) {
      final count = (Get.arguments?['questionCount'] as int?) ?? 5;
      _active = (List.of(_questions)..shuffle(Random())).take(count).toList();
      currentIndex = 0.obs;
    } else {
      _active = List.of(_questions);
      final svc = Get.find<ChildProgressService>();
      currentIndex = svc.sukuKataIndex.value.obs;
    }
    _loadQuestion();
  }

  void _saveProgress() {
    if (_isSaved) return;
    _isSaved = true;
    // Adventure mode tidak memakai resume index — skip saveGameResult
    if (_adventureMode) return;
    if (_sessionPlayedCount > 0) {
      try {
        Get.find<ChildProgressService>().saveGameResult(
          gameName: 'sukuKata',
          sessionCorrectCount: _correctCount,
          totalGameQuestions: _questions.length,
          sessionPlayedCount: _sessionPlayedCount,
          lastIndex: currentIndex.value,
          wrongWords: _wrongWords,
        );
      } catch (e) {
        debugPrint('Error saving progress: $e');
      }
    }
  }

  @override
  void onClose() {
    _saveProgress();
    super.onClose();
  }

  void _loadQuestion() {
    final count = letters.length;
    final indices = List.generate(count, (i) => i)..shuffle(Random());
    shuffledTileIndices.value = indices;
    slotTileIndex.value = List.filled(count, -1);
    tileUsed.value = List.filled(count, false);
  }

  void _reshuffleAndReset() {
    final count = letters.length;
    final indices = List.generate(count, (i) => i)..shuffle(Random());
    shuffledTileIndices.value = indices;
    slotTileIndex.value = List.filled(count, -1);
    tileUsed.value = List.filled(count, false);
  }

  void tapTile(int originalIdx) {
    if (tileUsed[originalIdx]) return;
    final emptySlot = slotTileIndex.indexWhere((i) => i == -1);
    if (emptySlot == -1) return;
    try { Get.find<FeedbackService>().tap(); } catch (_) {}
    slotTileIndex[emptySlot] = originalIdx;
    tileUsed[originalIdx] = true;
    slotTileIndex.refresh();
    tileUsed.refresh();
  }

  void tapSlot(int slotIndex) {
    final tIdx = slotTileIndex[slotIndex];
    if (tIdx == -1) return;
    try { Get.find<FeedbackService>().tap(); } catch (_) {}
    tileUsed[tIdx] = false;
    slotTileIndex[slotIndex] = -1;
    slotTileIndex.refresh();
    tileUsed.refresh();
  }

  bool get allSlotsFilled => slotTileIndex.every((i) => i != -1);

  void checkAnswer() {
    if (!allSlotsFilled) {
      Get.snackbar(
        'Belum Lengkap',
        'Ketuk semua huruf untuk mengisi kata!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE8621A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final answer = slotTileIndex.map((i) => letters[i]).join('');
    final isCorrect = answer == word;
    _sessionPlayedCount++;
    if (isCorrect) {
      _correctCount++;
    } else {
      _wrongWords.add(word);
      try { Get.find<FeedbackService>().wrong(); } catch (_) {}
      if (_adventureMode) {
        try { Get.find<ChildProgressService>().loseHeart(); } catch (_) {}
      }
    }
    _showResultSheet(isCorrect: isCorrect);
  }

  void _showResultSheet({required bool isCorrect}) {
    final isLast = currentIndex.value == _active.length - 1;
    final displayWord =
        word[0] + word.substring(1).toLowerCase();

    Get.bottomSheet(
      _ResultSheet(
        isCorrect: isCorrect,
        correctWord: displayWord,
        onNext: () {
          Get.back();
          if (isLast) {
            _saveProgress();
            Get.back(
              result: _adventureMode
                  ? {'correct': _correctCount, 'total': _active.length}
                  : (_tutorialMode ? true : null),
            );
          } else {
            currentIndex.value++;
            _loadQuestion();
          }
          if (!isCorrect) _reshuffleAndReset();
        },
      ),
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
    );
  }
}

// ─── Result Bottom Sheet ──────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  const _ResultSheet({
    required this.isCorrect,
    required this.correctWord,
    required this.onNext,
  });

  final bool isCorrect;
  final String correctWord;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final accent =
        isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    final accentDark =
        isCorrect ? const Color(0xFF338A3E) : const Color(0xFFC62828);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: accent,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Luar Biasa!' : 'Yuk, Coba Lagi',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Jawaban yang Benar:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            correctWord,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                decoration: BoxDecoration(
                  color: accentDark,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      'Lanjut',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
