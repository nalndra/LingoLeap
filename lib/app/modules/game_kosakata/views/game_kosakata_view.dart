import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/game_kosakata_controller.dart';
import '../../../widgets/adventure_hearts_bar.dart';

class GameKosakataView extends GetView<GameKosakataController> {
  const GameKosakataView({super.key});

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
                    const SizedBox(height: 24),
                    if (controller.adventureMode) ...[
                      const AdventureHeartsBar(),
                      const SizedBox(height: 14),
                    ],
                    _buildInstructionBox(),
                    const SizedBox(height: 20),
                    _buildAnswerSlots(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app_rounded,
                            size: 13, color: Color(0xFFBBBBBB)),
                        const SizedBox(width: 4),
                        Text(
                          'Ketuk suku kata di kotak untuk menghapusnya',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFFBBBBBB),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBubbles(),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
        'Ketuk gelembung gelembung untuk membentuk sebuah kata!',
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

  // ─── Answer slots ──────────────────────────────────────────────────────────

  Widget _buildAnswerSlots() {
    return Obx(() {
      final slots = controller.slotBubbleIndex;
      final syllables = controller.syllables;
      final count = slots.length;

      return LayoutBuilder(
        builder: (_, constraints) {
          const gap = 8.0;
          final slotSize =
              ((constraints.maxWidth - gap * (count - 1)) / count)
                  .clamp(48.0, 88.0);
          final fontSize = (slotSize * 0.27).clamp(13.0, 24.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              final bIdx = slots[i];
              final isEmpty = bIdx == -1;
              final color = isEmpty
                  ? null
                  : GameKosakataController.bubbleColors[
                      bIdx % GameKosakataController.bubbleColors.length];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: gap / 2),
                child: GestureDetector(
                  onTap: () => controller.tapSlot(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: slotSize,
                    height: slotSize,
                    decoration: BoxDecoration(
                      color: isEmpty ? Colors.white : color,
                      borderRadius: BorderRadius.circular(16),
                      border: isEmpty
                          ? Border.all(color: const Color(0xFF4CAF50), width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isEmpty ? '?' : syllables[bIdx],
                        style: GoogleFonts.poppins(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          color: isEmpty
                              ? const Color(0xFF4CAF50)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );
    });
  }

  // ─── Bubbles ───────────────────────────────────────────────────────────────

  Widget _buildBubbles() {
    return Obx(() {
      final syllables = controller.syllables;
      final used = controller.bubbleUsed;
      final shuffled = controller.shuffledBubbleIndices;
      if (shuffled.isEmpty) return const SizedBox.shrink();

      // Build rows from shuffled order: max 2 per row
      final rows = <List<int>>[];
      for (var i = 0; i < shuffled.length; i += 2) {
        rows.add([
          shuffled[i],
          if (i + 1 < shuffled.length) shuffled[i + 1],
        ]);
      }

      return LayoutBuilder(
        builder: (_, constraints) {
          const gap = 16.0;
          final bubbleSize =
              ((constraints.maxWidth - gap * 3) / 2).clamp(72.0, 120.0);
          final fontSz = (bubbleSize * 0.22).clamp(14.0, 26.0);

          return Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((originalIdx) {
                    final color = GameKosakataController.bubbleColors[
                        originalIdx % GameKosakataController.bubbleColors.length];
                    final isUsed = used[originalIdx];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: gap / 2),
                      child: GestureDetector(
                        onTap: () => controller.tapBubble(originalIdx),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isUsed ? 0.3 : 1.0,
                          child: Container(
                            width: bubbleSize,
                            height: bubbleSize,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: isUsed
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: Text(
                                syllables[originalIdx],
                                style: GoogleFonts.poppins(
                                  fontSize: fontSz,
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
                ),
              );
            }).toList(),
          );
        },
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
}
