import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

  static const _gameColors = [
    Color(0xFF2977C7), Color(0xFF7C3AED),
    Color(0xFFE8621A), Color(0xFF4CAF50),
  ];
  static const _gameDarkColors = [
    Color(0xFF1A5EA0), Color(0xFF5B21B6),
    Color(0xFFBF4D10), Color(0xFF338A3E),
  ];
  static const _gameIcons = [
    Icons.volume_up_rounded, Icons.headphones_rounded,
    Icons.extension_rounded, Icons.menu_book_rounded,
  ];
  static const _gameNames = ['Fonem Kata', 'Rima Kata', 'Suku Kata', 'Kosakata'];
  static const _gameDescs = [
    'Dengar kata lalu pilih huruf di posisi yang ditanyakan',
    'Pilih kata lain yang bunyinya sama di bagian akhir',
    'Susun suku kata menjadi satu kata yang utuh',
    'Susun huruf-huruf menjadi satu kata yang benar',
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F0E8),
        body: SafeArea(
          child: Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: KeyedSubtree(
                  key: ValueKey(controller.step),
                  child: _buildForStep(controller.step),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildForStep(TutorialStep s) {
    switch (s) {
      case TutorialStep.welcome:       return _buildWelcome();
      case TutorialStep.introFonem:    return _buildIntro(0);
      case TutorialStep.congratsFonem: return _buildCongrats(0, nextGameIdx: 1);
      case TutorialStep.introRima:     return _buildIntro(1);
      case TutorialStep.congratsRima:  return _buildCongrats(1, nextGameIdx: 2);
      case TutorialStep.introSu:       return _buildIntro(2);
      case TutorialStep.congratsSu:    return _buildCongrats(2, nextGameIdx: 3);
      case TutorialStep.introKo:       return _buildIntro(3);
      case TutorialStep.congratsKo:    return _buildCongrats(3, nextGameIdx: -1);
    }
  }

  // ── Top bar (tanpa back button) ──────────────────────────────────────────────

  Widget _topBar() {
    return Container(
      color: const Color(0xFFF5F0E8),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: controller.overallProgress,
              minHeight: 10,
              backgroundColor: const Color(0xFFDDDDDD),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2977C7)),
            ),
          )),
    );
  }

  // ── Lippo avatar ─────────────────────────────────────────────────────────────

  Widget _lippo(double size) {
    return Image.asset('assets/icons/lippo_icon.png',
        width: size, height: size, fit: BoxFit.contain);
  }

  // ── Game step dots ────────────────────────────────────────────────────────────

  Widget _gameDots(int active) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isActive = i == active;
        final isDone   = i < active;
        final color    = _gameColors[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: isActive ? 50 : 38,
              height: isActive ? 50 : 38,
              decoration: BoxDecoration(
                color: isActive || isDone ? color : const Color(0xFFDDDDDD),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check_rounded : _gameIcons[i],
                color: Colors.white,
                size: isActive ? 24 : 17,
              ),
            ),
            const SizedBox(height: 5),
            Text(_gameNames[i],
                style: GoogleFonts.poppins(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: isActive || isDone ? color : const Color(0xFFBBBBBB))),
          ]),
        );
      }),
    );
  }

  // ── Primary button ────────────────────────────────────────────────────────────

  Widget _btn(String label, Color main, Color dark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(50)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: main, borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WELCOME
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildWelcome() {
    return Column(children: [
      _topBar(),
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(children: [
                _lippo(68),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, aku Lippo!',
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.w900,
                              color: const Color(0xFF222222))),
                      const SizedBox(height: 4),
                      Text('Aku akan pandumu belajar\n4 permainan seru.',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w500,
                              color: const Color(0xFF777777), height: 1.5)),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 28),
              Text('Yang akan kita pelajari',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: const Color(0xFF999999))),
              const SizedBox(height: 12),
              ...List.generate(4, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                          color: _gameColors[i],
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(_gameIcons[i], color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_gameNames[i],
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: const Color(0xFF333333))),
                          Text(_gameDescs[i],
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: const Color(0xFF999999),
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ]),
                ),
              )),
              const SizedBox(height: 24),
              _btn('Mulai Tutorial',
                  const Color(0xFF2977C7), const Color(0xFF1A5EA0),
                  controller.nextStep),
            ],
          ),
        ),
      ),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTRO per game
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildIntro(int gameIdx) {
    final color = _gameColors[gameIdx];
    final dark  = _gameDarkColors[gameIdx];

    // Lippo speech per game
    const speeches = [
      'Aku akan mengucapkan sebuah kata, lalu kamu pilih huruf yang ada di posisi yang Lippo tanyakan.',
      'Lihat kata di kartu, lalu pilih kata lain yang berbunyi sama di bagian akhirnya.',
      'Lippo akan mengacak suku kata. Ketuk satu per satu untuk menyusunnya menjadi kata yang benar.',
      'Huruf-hurufnya sudah diacak. Ketuk dan susun kembali menjadi sebuah kata!',
    ];

    return Column(children: [
      _topBar(),
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(children: [
            _gameDots(gameIdx),
            const SizedBox(height: 32),

            // Game label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(11)),
                  child: Icon(_gameIcons[gameIdx], color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(_gameNames[gameIdx],
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
            const SizedBox(height: 28),

            // Lippo + speech bubble
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _lippo(56),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Text(
                      speeches[gameIdx],
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333), height: 1.6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

                    // Note: 2 soal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, color: color, size: 18),
                const SizedBox(width: 8),
                Text('2 soal latihan',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600, color: color)),
              ]),
            ),

            // Tip hapus — hanya untuk Suku Kata (2) dan Kosakata (3)
            if (gameIdx == 2 || gameIdx == 3) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCC02), width: 1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        gameIdx == 2
                            ? 'Kalau salah susun, ketuk lagi huruf yang sudah ada di kotak hijau untuk menghapusnya!'
                            : 'Kalau salah susun, ketuk lagi suku kata yang sudah ada di kotak untuk menghapusnya!',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7A6000),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 36),
            _btn('Ayo Coba', color, dark, controller.nextStep),
          ]),
        ),
      ),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONGRATS (antar mini-game)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCongrats(int doneGameIdx, {required int nextGameIdx}) {
    final doneColor = _gameColors[doneGameIdx];
    final isDone    = nextGameIdx == -1;
    final btnColor  = isDone ? const Color(0xFF2977C7) : _gameColors[nextGameIdx];
    final btnDark   = isDone ? const Color(0xFF1A5EA0) : _gameDarkColors[nextGameIdx];
    final btnLabel  = isDone ? 'Selesai' : 'Lanjut ke ${_gameNames[nextGameIdx]}';

    return Column(children: [
      _topBar(),
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _lippo(80),
              const SizedBox(height: 20),
              Text('Bagus sekali!',
                  style: GoogleFonts.poppins(
                      fontSize: 26, fontWeight: FontWeight.w900,
                      color: const Color(0xFF222222))),
              const SizedBox(height: 8),
              Text(
                'Kamu berhasil menyelesaikan\n${_gameNames[doneGameIdx]}.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 15, color: const Color(0xFF777777), height: 1.6),
              ),
              const SizedBox(height: 28),

              // Badge mini-game selesai
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                        color: doneColor, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_gameNames[doneGameIdx],
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: const Color(0xFF333333))),
                      Text('2/2 soal selesai',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: const Color(0xFF999999))),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.stars_rounded, color: doneColor, size: 22),
                ]),
              ),

              // Pratinjau mini-game berikutnya
              if (!isDone) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: _gameColors[nextGameIdx].withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _gameColors[nextGameIdx].withValues(alpha: 0.25)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                          color: _gameColors[nextGameIdx],
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(_gameIcons[nextGameIdx],
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selanjutnya',
                            style: GoogleFonts.poppins(
                                fontSize: 11, fontWeight: FontWeight.w600,
                                color: _gameColors[nextGameIdx])),
                        Text(_gameNames[nextGameIdx],
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w700,
                                color: const Color(0xFF333333))),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_rounded,
                        color: _gameColors[nextGameIdx], size: 20),
                  ]),
                ),
              ],

              const SizedBox(height: 36),
              _btn(btnLabel, btnColor, btnDark, controller.nextStep),
            ],
          ),
        ),
      ),
    ]);
  }

}
