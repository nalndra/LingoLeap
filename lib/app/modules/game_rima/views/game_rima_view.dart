import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/game_rima_controller.dart';
import '../../../widgets/adventure_hearts_bar.dart';

class GameRimaView extends GetView<GameRimaController> {
  const GameRimaView({super.key});

  static const _optionPairs = [
    [Color(0xFF2977C7), Color(0xFF1A5EA0)],
    [Color(0xFFE8621A), Color(0xFFBF4D10)],
    [Color(0xFF4CAF50), Color(0xFF338A3E)],
  ];

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
                    _buildWordCard(),
                    const SizedBox(height: 24),
                    _buildOptions(),
                    const SizedBox(height: 28),
                    _buildPeriksaButton(),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
        'Ketuk  Rima yang sesuai dengan kata!',
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

  // ─── Word card ─────────────────────────────────────────────────────────────

  Widget _buildWordCard() {
    return Obx(() {
      final loading = controller.isLoading.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: loading
            ? _buildLoadingCard()
            : _buildContentCard(
                key: ValueKey(controller.currentIndex.value),
              ),
      );
    });
  }

  Widget _buildLoadingCard() {
    return Container(
      key: const ValueKey('loading'),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2977C7),
          strokeWidth: 3.5,
        ),
      ),
    );
  }

  Widget _buildContentCard({Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Emoji area
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: controller.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Center(
              child: Text(
                controller.emoji,
                style: const TextStyle(fontSize: 96),
              ),
            ),
          ),

          // Word pill
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF338A3E),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    controller.word,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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

  // ─── Option buttons ────────────────────────────────────────────────────────

  Widget _buildOptions() {
    return Obx(() {
      final loading  = controller.isLoading.value;
      final options  = controller.shuffledOptions;
      final selected = controller.selectedOptionIdx.value;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: loading ? 0.0 : 1.0,
        child: Column(
          children: List.generate(options.length, (i) {
            final pair = _optionPairs[i % _optionPairs.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildOptionButton(
                label: options.isEmpty ? '' : options[i],
                mainColor: pair[0],
                darkColor: pair[1],
                isSelected: selected == i,
                onTap: () => controller.selectOption(i),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildOptionButton({
    required String label,
    required Color mainColor,
    required Color darkColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mainColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  )
                ]
              : null,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: EdgeInsets.only(bottom: isSelected ? 2 : 5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 22),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              padding: const EdgeInsets.symmetric(vertical: 18),
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
