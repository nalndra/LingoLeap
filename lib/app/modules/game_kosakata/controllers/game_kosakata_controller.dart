import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class _WordQuestion {
  final String word;
  final List<String> syllables;
  const _WordQuestion(this.word, this.syllables);
}

class GameKosakataController extends GetxController {
  static const List<Color> bubbleColors = [
    Color(0xFF2977C7), // blue
    Color(0xFF4CAF50), // green
    Color(0xFFE8621A), // orange
    Color(0xFF7C3AED), // purple
  ];

  static const _questions = [
    // ── 3 suku kata – familiar ───────────────────────────────────────────────
    _WordQuestion('SEPATU',   ['SE', 'PA', 'TU']),
    _WordQuestion('CELANA',   ['CE', 'LA', 'NA']),
    _WordQuestion('KELAPA',   ['KE', 'LA', 'PA']),
    _WordQuestion('KEPALA',   ['KE', 'PA', 'LA']),
    _WordQuestion('TELINGA',  ['TE', 'LI', 'NGA']),
    _WordQuestion('SEMANGKA', ['SE', 'MANG', 'KA']),
    _WordQuestion('BERMAIN',  ['BER', 'MA', 'IN']),
    _WordQuestion('BERLARI',  ['BER', 'LA', 'RI']),
    _WordQuestion('BELAJAR',  ['BE', 'LA', 'JAR']),
    _WordQuestion('MEMBACA',  ['MEM', 'BA', 'CA']),
    _WordQuestion('BERHASIL', ['BER', 'HA', 'SIL']),
    _WordQuestion('BERSAMA',  ['BER', 'SA', 'MA']),
    _WordQuestion('BERUANG',  ['BE', 'RU', 'ANG']),
    _WordQuestion('BERGERAK', ['BER', 'GE', 'RAK']),
    _WordQuestion('BERTEMAN', ['BER', 'TE', 'MAN']),

    // ── 4 suku kata – lebih sulit ────────────────────────────────────────────
    _WordQuestion('KELUARGA',    ['KE', 'LU', 'AR', 'GA']),
    _WordQuestion('PELAJARAN',   ['PE', 'LA', 'JAR', 'AN']),
    _WordQuestion('MEMBACAKAN',  ['MEM', 'BA', 'CA', 'KAN']),
    _WordQuestion('PERJALANAN',  ['PER', 'JA', 'LAN', 'AN']),
    _WordQuestion('BERSEMANGAT', ['BER', 'SE', 'MA', 'NGAT']),
  ];

  final currentIndex = 0.obs;
  final shuffledBubbleIndices = <int>[].obs;
  final slotBubbleIndex = <int>[].obs;
  final bubbleUsed = <bool>[].obs;

  List<String> get syllables => _questions[currentIndex.value].syllables;
  String get word => _questions[currentIndex.value].word;
  int get totalQuestions => _questions.length;
  double get progress => (currentIndex.value + 1) / totalQuestions;

  @override
  void onInit() {
    super.onInit();
    _loadQuestion();
  }

  void _loadQuestion() {
    final count = _questions[currentIndex.value].syllables.length;
    final indices = List.generate(count, (i) => i)..shuffle(Random());
    shuffledBubbleIndices.value = indices;
    slotBubbleIndex.value = List.filled(count, -1);
    bubbleUsed.value = List.filled(count, false);
  }

  void _reshuffleAndReset() {
    final count = syllables.length;
    final indices = List.generate(count, (i) => i)..shuffle(Random());
    shuffledBubbleIndices.value = indices;
    slotBubbleIndex.value = List.filled(count, -1);
    bubbleUsed.value = List.filled(count, false);
  }

  void tapBubble(int originalIdx) {
    if (bubbleUsed[originalIdx]) return;
    final emptySlot = slotBubbleIndex.indexWhere((i) => i == -1);
    if (emptySlot == -1) return;
    slotBubbleIndex[emptySlot] = originalIdx;
    bubbleUsed[originalIdx] = true;
    slotBubbleIndex.refresh();
    bubbleUsed.refresh();
  }

  void tapSlot(int slotIndex) {
    final bIdx = slotBubbleIndex[slotIndex];
    if (bIdx == -1) return;
    bubbleUsed[bIdx] = false;
    slotBubbleIndex[slotIndex] = -1;
    slotBubbleIndex.refresh();
    bubbleUsed.refresh();
  }

  bool get allSlotsFilled => slotBubbleIndex.every((i) => i != -1);

  void checkAnswer() {
    if (!allSlotsFilled) {
      Get.snackbar(
        'Belum Lengkap',
        'Ketuk semua gelembung untuk mengisi kata!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE8621A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final answer = slotBubbleIndex.map((i) => syllables[i]).join('');
    if (answer == word) {
      _showResultSheet(isCorrect: true);
    } else {
      _showResultSheet(isCorrect: false);
    }
  }

  void _showResultSheet({required bool isCorrect}) {
    final isLast = currentIndex.value == _questions.length - 1;
    final correctWord =
        word[0] + word.substring(1).toLowerCase(); // "Sepatu"

    Get.bottomSheet(
      _ResultSheet(
        isCorrect: isCorrect,
        correctWord: correctWord,
        onNext: () {
          Get.back();
          if (isLast) {
            Get.back(); // kembali ke latihan
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
    final accent = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
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
          // Icon + judul
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
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
          // Tombol Lanjut
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
