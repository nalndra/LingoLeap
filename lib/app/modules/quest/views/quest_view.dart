import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/quest_controller.dart';
import '../../../routes/app_pages.dart';

class QuestView extends GetView<QuestController> {
  const QuestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildFrogBanner(),
            const SizedBox(height: 40),
            _buildQuestCard(),
            const SizedBox(height: 24),
            _buildContinueButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Frog Banner ─────────────────────────────────────────────────────────────

  Widget _buildFrogBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/quest/frog_waterfall.png',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/profile/frog_icon.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quest Card ───────────────────────────────────────────────────────────────

  Widget _buildQuestCard() {
    return Obx(() {
      final lvl = controller.todayLevelIdx.value;
      final def = controller.todayDef;
      if (def == null) return const SizedBox.shrink();

      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  def.name,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: def.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Level $lvl',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.flag_rounded, color: def.color, size: 22),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Level ${lvl + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: def.color,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.card_giftcard_rounded,
                        color: def.color, size: 22),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (lvl % 4 + 1) / 4,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFDDE8F5),
                    valueColor: AlwaysStoppedAnimation<Color>(def.color),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite,
                        color: Color(0xFFE53935), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '+1',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Text('✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(
                      '+${controller.bonusXp} XP',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Icon badge di atas card
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: def.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: def.color.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(def.icon, color: Colors.white, size: 36),
          ),
        ],
      );
    });
  }

  // ─── Continue / Quest Reward Button ──────────────────────────────────────────

  Widget _buildContinueButton() {
    return Obx(() {
      final hasPending =
          controller.isTodayCompleted && !controller.isClaimedToday;
      return hasPending ? _buildRewardButton() : _buildGoButton();
    });
  }

  Widget _buildGoButton() {
    return _ActionButton(
      label: 'Lanjutkan Petualangan',
      color: const Color(0xFF2977C7),
      darkColor: const Color(0xFF1A5EA0),
      onTap: () => Get.toNamed(Routes.PETUALANGAN),
    );
  }

  Widget _buildRewardButton() {
    return _ActionButton(
      label: '🎁  Ambil Hadiah Quest',
      color: const Color(0xFF4CAF50),
      darkColor: const Color(0xFF338A3E),
      onTap: () async {
        await controller.claimReward();
        Get.snackbar(
          'Hadiah Diterima! 🎉',
          '+1 ❤️  +${controller.bonusXp} ✨ XP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }
}

// ─── Reusable 3-D action button ──────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.darkColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color darkColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
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
