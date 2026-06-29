import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../../services/child_progress_service.dart';
import 'package:google_fonts/google_fonts.dart';

class _FonemQuestion {
  final String word;
  final int letterIndex;
  const _FonemQuestion(this.word, this.letterIndex);

  String get correctLetter => word[letterIndex];

  String get positionLabel {
    if (letterIndex == 0) return 'DEPAN';
    if (letterIndex == word.length - 1) return 'BELAKANG';
    const labels = ['', '', 'KEDUA', 'KETIGA', 'KEEMPAT', 'KELIMA', 'KEENAM'];
    return (letterIndex + 1 < labels.length)
        ? labels[letterIndex + 1]
        : 'KE-${letterIndex + 1}';
  }
}

class GameFonemController extends GetxController {
  static const tileColors = [
    Color(0xFF2977C7),
    Color(0xFF4CAF50),
    Color(0xFFE8621A),
    Color(0xFFE8A020),
    Color(0xFF7C3AED),
    Color(0xFF00ACC1),
  ];
  static const tileDarkColors = [
    Color(0xFF1A5EA0),
    Color(0xFF338A3E),
    Color(0xFFBF4D10),
    Color(0xFFB87A10),
    Color(0xFF5B21B6),
    Color(0xFF00838F),
  ];

  static const _questions = [
    // ── DEPAN ─────────────────────────────────────────────────────────────────
    _FonemQuestion('BOLA', 0),
    _FonemQuestion('MEJA', 0),
    _FonemQuestion('TOPI', 0),
    _FonemQuestion('SAPI', 0),
    _FonemQuestion('GULA', 0),
    _FonemQuestion('RUMAH', 0),
    _FonemQuestion('PISAU', 0),
    _FonemQuestion('BUNGA', 0),

    // ── BELAKANG ──────────────────────────────────────────────────────────────
    _FonemQuestion('BOLA', 3),
    _FonemQuestion('RUMAH', 4),
    _FonemQuestion('PINTU', 4),
    _FonemQuestion('TEMAN', 4),
    _FonemQuestion('BUNGA', 4),
    _FonemQuestion('KARUNG', 5),

    // ── KEDUA ─────────────────────────────────────────────────────────────────
    _FonemQuestion('BOLA', 1),
    _FonemQuestion('TEMAN', 1),
    _FonemQuestion('PISAU', 1),
    _FonemQuestion('GARUDA', 1),
    _FonemQuestion('BUNGA', 1),

    // ── KETIGA ────────────────────────────────────────────────────────────────
    _FonemQuestion('BUNGA', 2),
    _FonemQuestion('PISAU', 2),
    _FonemQuestion('KARUNG', 2),
    _FonemQuestion('GARUDA', 2),
    _FonemQuestion('BERLARI', 2),

    // ── KEEMPAT ───────────────────────────────────────────────────────────────
    _FonemQuestion('GARUDA', 3),
    _FonemQuestion('BERLARI', 3),
    _FonemQuestion('KARUNG', 3),

    // ── KELIMA ────────────────────────────────────────────────────────────────
    _FonemQuestion('BERLARI', 4),
    _FonemQuestion('KARUNG', 4),
  ];

  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  final _tts = FlutterTts();
  late final RxInt currentIndex;
  final isSpeaking = false.obs;
  final hasPlayed = false.obs;
  final _tapCount = 0.obs;  // internal — hidden feature
  final shuffledOptions = <String>[].obs;
  int _correctCount = 0;
  int _sessionPlayedCount = 0;
  final List<String> _wrongWords = [];
  bool _isSaved = false;

  // Normal mode: tidak diacak agar resume index konsisten
  // Tutorial/adventure mode: diacak, ambil 2
  List<_FonemQuestion> _shuffled = [];
  bool _tutorialMode = false;
  bool _adventureMode = false;

  _FonemQuestion get _current => _shuffled[currentIndex.value];
  String get word => _current.word;
  String get positionLabel => _current.positionLabel;
  String get correctLetter => _current.correctLetter;
  int get totalQuestions => _shuffled.length;
  double get progress => (currentIndex.value + 1) / totalQuestions;

  @override
  void onInit() {
    super.onInit();
    _tutorialMode = Get.arguments?['tutorialMode'] == true;
    _adventureMode = Get.arguments?['adventureMode'] == true;
    if (_tutorialMode) {
      _shuffled = (List.of(_questions)..shuffle(Random())).take(2).toList();
      currentIndex = 0.obs;
    } else {
      _shuffled = List.of(_questions);
      final svc = Get.find<ChildProgressService>();
      currentIndex = svc.fonemIndex.value.obs;
    }
    _initTts();
    _loadQuestion();
  }

  @override
  void onClose() {
    _saveProgress();
    try { _tts.stop(); } catch (_) {}
    super.onClose();
  }

  void _saveProgress() {
    if (_isSaved) return;
    _isSaved = true;
    if (_sessionPlayedCount > 0) {
      try {
        Get.find<ChildProgressService>().saveGameResult(
          gameName: 'fonem',
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

  String? _idLang;

  Future<void> _initTts() async {
    try {
      _tts.setCompletionHandler(() => isSpeaking.value = false);
      _tts.setCancelHandler(() => isSpeaking.value = false);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.45);
      _idLang = await _resolveIdLang();
    } catch (_) {}
  }

  Future<String?> _resolveIdLang() async {
    // Cek voices yang tersedia, cari yang Indonesian
    try {
      final voices = await _tts.getVoices as List?;
      if (voices != null) {
        for (final v in voices) {
          final locale = ((v as Map)['locale'] ?? '').toString().toLowerCase();
          if (locale.startsWith('id') || locale == 'in-id') {
            return (v['locale'] as String?) ?? 'id-ID';
          }
        }
      }
    } catch (_) {}

    // Fallback: coba satu per satu kode bahasa
    for (final lang in ['id-ID', 'in-ID', 'id', 'in']) {
      try {
        final ok = await _tts.setLanguage(lang);
        if (ok == 1) return lang;
      } catch (_) {}
    }
    return null;
  }

  void _loadQuestion() {
    hasPlayed.value = false;
    _tapCount.value = 0;
    shuffledOptions.value = _generateOptions(_current.correctLetter);
  }

  List<String> _generateOptions(String correct) {
    final pool = _alphabet
        .split('')
        .where((c) => c != correct)
        .toList()
      ..shuffle(Random());
    return ([correct, ...pool.take(5)]..shuffle(Random()));
  }

  Future<void> speakWord() async {
    if (isSpeaking.value) return;
    try {
      _tapCount.value++;
      isSpeaking.value = true;
      hasPlayed.value = true;

      final isNormal = _tapCount.value % 2 == 1;
      await _tts.setSpeechRate(isNormal ? 0.65 : 0.3);

      // Set bahasa setiap kali sebelum speak — diperlukan di beberapa platform
      if (_idLang != null) {
        await _tts.setLanguage(_idLang!);
      }
      await _tts.speak(word);
    } catch (_) {
      isSpeaking.value = false;
    }
  }

  void selectOption(String letter) {
    final isCorrect = letter == correctLetter;
    _sessionPlayedCount++;
    if (isCorrect) {
      _correctCount++;
    } else {
      _wrongWords.add(word);
    }
    _showResultSheet(isCorrect: isCorrect);
  }

  void _showResultSheet({required bool isCorrect}) {
    final isLast = currentIndex.value == _shuffled.length - 1;

    Get.bottomSheet(
      _ResultSheet(
        isCorrect: isCorrect,
        correctLetter: correctLetter,
        word: word,
        positionLabel: positionLabel,
        onNext: () {
          Get.back(); // tutup bottom sheet
          if (isLast) {
            _saveProgress();
            Get.back(result: (_tutorialMode || _adventureMode) ? true : null);
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
    required this.correctLetter,
    required this.word,
    required this.positionLabel,
    required this.onNext,
  });

  final bool isCorrect;
  final String correctLetter;
  final String word;
  final String positionLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final accent =
        isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    final accentDark =
        isCorrect ? const Color(0xFF338A3E) : const Color(0xFFC62828);
    final displayWord = word[0] + word.substring(1).toLowerCase();

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
          // ── Judul ──────────────────────────────────────────────────────────
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
          const SizedBox(height: 14),

          // ── Jawaban benar ───────────────────────────────────────────────────
          Text(
            'Jawaban yang Benar:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Letter tile
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF338A3E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      correctLetter,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Huruf $positionLabel dari',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  Text(
                    displayWord,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Tombol Lanjut ──────────────────────────────────────────────────
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
