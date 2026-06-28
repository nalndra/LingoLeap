import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/quest_controller.dart';

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
            const SizedBox(height: 20),
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
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/profile/frog_icon.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quest Card ───────────────────────────────────────────────────────────────

  Widget _buildQuestCard() {
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
                'Susun Kata',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF3DAA4C),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.flag_rounded,
                      color: Color(0xFF2977C7), size: 22),
                  Expanded(
                    child: Center(
                      child: Text(
                        '50%',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2977C7),
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.card_giftcard_rounded,
                      color: Color(0xFF2977C7), size: 22),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 12,
                  backgroundColor: Color(0xFFDDE8F5),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2977C7)),
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
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.bolt, color: Color(0xFFFFB300), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '+50 XP',
                    style: GoogleFonts.outfit(
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
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF3DAA4C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3DAA4C).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.extension_rounded,
              color: Colors.white, size: 36),
        ),
      ],
    );
  }

  // ─── Continue Button ─────────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F2342),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Material(
          color: const Color(0xFF1A3A6B),
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Lanjutkan Petualangan',
                  style: GoogleFonts.outfit(
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
