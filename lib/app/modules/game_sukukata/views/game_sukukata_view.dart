import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/game_sukukata_controller.dart';
import '../../../widgets/adventure_hearts_bar.dart';

class GameSukukataView extends GetView<GameSukukataController> {
  const GameSukukataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (controller.adventureMode) ...[
                      const AdventureHeartsBar(),
                      const SizedBox(height: 14),
                    ],
                    _buildInstructionBox(),
                    const SizedBox(height: 24),
                    _buildMainCard(),
                    const Spacer(),
                    _buildPeriksaButton(),
                    const SizedBox(height: 28),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        'Ketuk  huruf menjadi sebuah kata!',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4CAF50),
          height: 1.5,
        ),
      ),
    );
  }

  // ─── Main white card ───────────────────────────────────────────────────────

  Widget _buildMainCard() {
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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        children: [
          Text(
            'Susun huruf',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 24),
          _buildAnswerSlots(),
          const SizedBox(height: 24),
          _buildLetterTiles(),
        ],
      ),
    );
  }

  // ─── Answer slots ──────────────────────────────────────────────────────────

  Widget _buildAnswerSlots() {
    return Obx(() {
      final slots = controller.slotTileIndex;
      final ltrs = controller.letters;
      final count = slots.length;
      final tileSize = _tileSize(count);

      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: List.generate(count, (i) {
          final tIdx = slots[i];
          final isEmpty = tIdx == -1;

          return GestureDetector(
            onTap: () => controller.tapSlot(i),
            child: _buildSlotTile(
              isEmpty: isEmpty,
              letter: isEmpty ? '?' : ltrs[tIdx],
              colorIdx: isEmpty ? -1 : tIdx,
              size: tileSize,
            ),
          );
        }),
      );
    });
  }

  Widget _buildSlotTile({
    required bool isEmpty,
    required String letter,
    required int colorIdx,
    required double size,
  }) {
    if (isEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF338A3E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF4CAF50), width: 2.5),
          ),
          child: Center(
            child: Text(
              '?',
              style: GoogleFonts.poppins(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF4CAF50),
              ),
            ),
          ),
        ),
      );
    }

    final main = GameSukukataController.tileMainColors[
        colorIdx % GameSukukataController.tileMainColors.length];
    final dark = GameSukukataController.tileDarkColors[
        colorIdx % GameSukukataController.tileDarkColors.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: main,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            letter,
            style: GoogleFonts.poppins(
              fontSize: size * 0.42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Letter tiles ──────────────────────────────────────────────────────────

  Widget _buildLetterTiles() {
    return Obx(() {
      final shuffled = controller.shuffledTileIndices;
      final ltrs = controller.letters;
      final used = controller.tileUsed;
      if (shuffled.isEmpty) return const SizedBox.shrink();

      final tileSize = _tileSize(shuffled.length);

      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: shuffled.map((originalIdx) {
          final main = GameSukukataController.tileMainColors[
              originalIdx % GameSukukataController.tileMainColors.length];
          final dark = GameSukukataController.tileDarkColors[
              originalIdx % GameSukukataController.tileDarkColors.length];
          final isUsed = used[originalIdx];

          return GestureDetector(
            onTap: () => controller.tapTile(originalIdx),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isUsed ? 0.35 : 1.0,
              child: Container(
                width: tileSize,
                height: tileSize,
                decoration: BoxDecoration(
                  color: dark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: main,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      ltrs[originalIdx],
                      style: GoogleFonts.poppins(
                        fontSize: tileSize * 0.42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // ─── Periksa button ────────────────────────────────────────────────────────

  Widget _buildPeriksaButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A5EA0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2977C7),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            onTap: controller.checkAnswer,
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Periksa',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  double _tileSize(int count) {
    if (count <= 4) return 72;
    if (count == 5) return 62;
    return 54;
  }
}
