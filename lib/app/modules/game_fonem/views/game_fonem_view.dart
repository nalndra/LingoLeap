import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/game_fonem_controller.dart';
import '../../../widgets/adventure_hearts_bar.dart';

class GameFonemView extends GetView<GameFonemController> {
  const GameFonemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  children: [
                    if (controller.adventureMode) ...[
                      const AdventureHeartsBar(),
                      const SizedBox(height: 14),
                    ],
                    _buildInstructionBox(),
                    const SizedBox(height: 24),
                    _buildPlayCard(),
                    const SizedBox(height: 28),
                    _buildQuestion(),
                    const SizedBox(height: 24),
                    _buildOptionGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFFF5F0E8),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF2977C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(
                    value: controller.progress,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFDDDDDD),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2977C7)),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // ─── Instruction box ───────────────────────────────────────────────────────

  Widget _buildInstructionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
      ),
      child: Text(
        'Tekan tombol suara, dengarkan kata dengan teliti, lalu pilih huruf yang tepat!',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4CAF50),
          height: 1.4,
        ),
      ),
    );
  }

  // ─── Play card (NO letters shown — titik-titik saja) ──────────────────────

  Widget _buildPlayCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        children: [
          // Titik-titik menunjukkan jumlah huruf (tidak ada huruf yang tampil)
          Obx(() => _buildWordDots(controller.word.length)),
          const SizedBox(height: 28),
          // Tombol play besar
          Obx(() {
            final speaking = controller.isSpeaking.value;
            final played = controller.hasPlayed.value;

            return Column(
              children: [
                GestureDetector(
                  onTap: controller.speakWord,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A5EA0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2977C7)
                              .withValues(alpha: speaking ? 0.55 : 0.30),
                          blurRadius: speaking ? 24 : 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: speaking ? 0 : 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2977C7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        speaking
                            ? Icons.volume_up_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  played && !speaking
                      ? 'Ketuk untuk dengarkan lagi'
                      : speaking
                          ? ''
                          : 'Ketuk untuk dengarkan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWordDots(int count) {
    return Obx(() {
      final played = controller.hasPlayed.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          return Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: played
                  ? const Color(0xFF2977C7)
                  : const Color(0xFFCCCCCC),
              shape: BoxShape.circle,
            ),
          );
        }),
      );
    });
  }

  // ─── Question text ─────────────────────────────────────────────────────────

  Widget _buildQuestion() {
    return Obx(() {
      final pos = controller.positionLabel;
      return Column(
        children: [
          Text(
            'Huruf apa yang ada di',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF444444),
            ),
          ),
          Text(
            pos,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2977C7),
            ),
          ),
          Text(
            'kata tersebut?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF444444),
            ),
          ),
        ],
      );
    });
  }

  // ─── Option grid 2 × 3 ────────────────────────────────────────────────────

  Widget _buildOptionGrid() {
    return Obx(() {
      final options = controller.shuffledOptions;
      if (options.isEmpty) return const SizedBox.shrink();

      return LayoutBuilder(
        builder: (_, constraints) {
          const cols = 3;
          const gap = 10.0;
          final tileSize =
              ((constraints.maxWidth - gap * (cols + 1)) / cols)
                  .clamp(52.0, 88.0);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3, (i) => _buildOptionTile(options[i], i, tileSize, gap)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3,
                    (i) => _buildOptionTile(options[i + 3], i + 3, tileSize, gap)),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildOptionTile(String letter, int colorIdx, double size, double gap) {
    final main = GameFonemController.tileColors[
        colorIdx % GameFonemController.tileColors.length];
    final dark = GameFonemController.tileDarkColors[
        colorIdx % GameFonemController.tileDarkColors.length];
    final radius = size * 0.22;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap / 2),
      child: GestureDetector(
        onTap: () => controller.selectOption(letter),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dark,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: main,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(
              child: Text(
                letter,
                style: GoogleFonts.poppins(
                  fontSize: (size * 0.36).clamp(20.0, 32.0),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
