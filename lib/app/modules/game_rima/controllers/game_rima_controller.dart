import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/child_progress_service.dart';
import '../../../services/feedback_service.dart';
import 'package:google_fonts/google_fonts.dart';

class _RimaQuestion {
  final String word;
  final String emoji;
  final Color cardColor;
  final List<String> options; // options[0] selalu jawaban benar
  const _RimaQuestion(this.word, this.emoji, this.cardColor, this.options);
}

class GameRimaController extends GetxController {
  static const optionColors = [
    Color(0xFF2977C7),
    Color(0xFFE8621A),
    Color(0xFF4CAF50),
  ];
  static const optionDarkColors = [
    Color(0xFF1A5EA0),
    Color(0xFFBF4D10),
    Color(0xFF338A3E),
  ];

  // Emoji dipilih dari Unicode 6.0–9.0 agar didukung semua Android modern
  static const _questions = [
    _RimaQuestion('Kucing',  '🐱', Color(0xFF4A90D9), ['Pancing', 'Guling',  'Ayam'   ]),
    _RimaQuestion('Jari',   '☝️', Color(0xFF7C3AED), ['Lari',    'Mata',    'Buku'   ]),
    _RimaQuestion('Sapi',   '🐄', Color(0xFF4CAF50), ['Tapi',    'Baju',    'Meja'   ]),
    _RimaQuestion('Baju',   '👕', Color(0xFFE8621A), ['Maju',    'Bola',    'Kuda'   ]),
    _RimaQuestion('Mata',   '👀', Color(0xFF2977C7), ['Rata',    'Kuda',    'Buku'   ]),
    _RimaQuestion('Kuda',   '🐴', Color(0xFF00ACC1), ['Muda',    'Mata',    'Jari'   ]),
    _RimaQuestion('Buku',   '📖', Color(0xFF7C3AED), ['Suku',    'Baju',    'Kaki'   ]),
    _RimaQuestion('Topi',   '🎩', Color(0xFFE8A020), ['Kopi',    'Baju',    'Meja'   ]),
    _RimaQuestion('Gula',   '🍬', Color(0xFFE8621A), ['Bola',    'Meja',    'Kuda'   ]),
    _RimaQuestion('Kaki',   '👣', Color(0xFF4CAF50), ['Baki',    'Sapi',    'Topi'   ]),
    _RimaQuestion('Roti',   '🍞', Color(0xFF2977C7), ['Nanti',   'Kaki',    'Baju'   ]),
    _RimaQuestion('Pisang', '🍌', Color(0xFFE8A020), ['Pasang',  'Bintang', 'Kucing' ]),
    _RimaQuestion('Bintang','⭐', Color(0xFF7C3AED), ['Datang',  'Pisang',  'Kancing']),
    _RimaQuestion('Bulan',  '🌙', Color(0xFF00ACC1), ['Jalan',   'Gula',    'Baju'   ]),
    _RimaQuestion('Tangan', '✋', Color(0xFFE8621A), ['Jangan',  'Pisang',  'Bintang']),
  ];

  late final RxInt currentIndex;
  final selectedOptionIdx  = (-1).obs;
  final isLoading          = true.obs;
  final shuffledOptions    = <String>[].obs;
  final _correctDisplayIdx = 0.obs;
  int _correctCount = 0;
  int _sessionPlayedCount = 0;
  final List<String> _wrongWords = [];
  bool _isSaved = false;

  List<_RimaQuestion> _shuffled = [];
  bool _tutorialMode = false;
  bool _adventureMode = false;

  _RimaQuestion get _current  => _shuffled[currentIndex.value];
  String  get word            => _current.word;
  String  get emoji           => _current.emoji;
  Color   get cardColor       => _current.cardColor;
  int     get totalQuestions  => _shuffled.length;
  double  get progress        => (currentIndex.value + 1) / totalQuestions;
  int     get correctDisplayIdx => _correctDisplayIdx.value;
  bool    get adventureMode   => _adventureMode;

  @override
  void onInit() {
    super.onInit();
    _tutorialMode = Get.arguments?['tutorialMode'] == true;
    _adventureMode = Get.arguments?['adventureMode'] == true;
    if (_tutorialMode) {
      _shuffled = (List.of(_questions)..shuffle(Random())).take(2).toList();
      currentIndex = 0.obs;
    } else if (_adventureMode) {
      final count = (Get.arguments?['questionCount'] as int?) ?? 5;
      _shuffled = (List.of(_questions)..shuffle(Random())).take(count).toList();
      currentIndex = 0.obs;
    } else {
      _shuffled = List.of(_questions);
      final svc = Get.find<ChildProgressService>();
      currentIndex = svc.rimaIndex.value.obs;
    }
    _loadQuestion();
  }

  void _saveProgress() {
    if (_isSaved) return;
    _isSaved = true;
    if (_adventureMode) return;
    if (_sessionPlayedCount > 0) {
      try {
        Get.find<ChildProgressService>().saveGameResult(
          gameName: 'rima',
          sessionCorrectCount: _correctCount,
          totalGameQuestions: _shuffled.length,
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

  Future<void> _loadQuestion() async {
    isLoading.value = true;
    selectedOptionIdx.value = -1;

    await Future.delayed(const Duration(milliseconds: 320));

    final opts    = List.of(_current.options);
    final correct = opts[0];
    opts.shuffle(Random());
    _correctDisplayIdx.value = opts.indexOf(correct);
    shuffledOptions.value    = opts;

    isLoading.value = false;
  }

  void selectOption(int displayIdx) {
    if (isLoading.value) return;
    try { Get.find<FeedbackService>().tap(); } catch (_) {}
    selectedOptionIdx.value = displayIdx;
  }

  void checkAnswer() {
    if (isLoading.value) return;
    if (selectedOptionIdx.value == -1) {
      Get.snackbar(
        'Pilih dulu!',
        'Pilih salah satu kata yang berima.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE8621A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    _sessionPlayedCount++;
    final isCorrect = selectedOptionIdx.value == _correctDisplayIdx.value;
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
    final isLast      = currentIndex.value == _shuffled.length - 1;
    final correctWord = shuffledOptions[_correctDisplayIdx.value];

    Get.bottomSheet(
      _ResultSheet(
        isCorrect: isCorrect,
        targetWord: word,
        correctRhyme: correctWord,
        onNext: () {
          Get.back(); // tutup bottom sheet
          if (isLast) {
            _saveProgress();
            Get.back(
              result: _adventureMode
                  ? {'correct': _correctCount, 'total': _shuffled.length}
                  : (_tutorialMode ? true : null),
            );
          } else {
            currentIndex.value++;
            _loadQuestion();
          }
        },
      ),
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
    );
  }
}

// ─── Result Sheet ─────────────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  const _ResultSheet({
    required this.isCorrect,
    required this.targetWord,
    required this.correctRhyme,
    required this.onNext,
  });

  final bool isCorrect;
  final String targetWord;
  final String correctRhyme;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final accent     = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    final accentDark = isCorrect ? const Color(0xFF338A3E) : const Color(0xFFC62828);

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
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 17,
                color: const Color(0xFF222222),
              ),
              children: [
                TextSpan(
                  text: targetWord,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '  →  berima dengan  '),
                TextSpan(
                  text: correctRhyme,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: accent,
                  ),
                ),
              ],
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
