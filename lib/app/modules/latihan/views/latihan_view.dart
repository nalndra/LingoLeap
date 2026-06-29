import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/latihan_controller.dart';

class LatihanView extends GetView<LatihanController> {
  const LatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // Top nav bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2977C7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Latihan',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable cards
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  children: [
                    _ExerciseCard(
                      title: 'Suku Kata',
                      subtitle: 'Pilih dan susun kata',
                      icon: Icons.extension_rounded,
                      iconBgColor: const Color(0xFF2977C7),
                      onTap: () => Get.toNamed(Routes.GAME_SUKUKATA),
                    ),
                    const SizedBox(height: 16),
                    _ExerciseCard(
                      title: 'Kosakata',
                      subtitle: 'Pilih dan susun huruf',
                      icon: Icons.menu_book_rounded,
                      iconBgColor: const Color(0xFF4CAF50),
                      onTap: () => Get.toNamed(Routes.GAME_KOSAKATA),
                    ),
                    const SizedBox(height: 16),
                    _ExerciseCard(
                      title: 'Fonem Kata',
                      subtitle: 'Dengar bunyi dan pilih',
                      icon: Icons.volume_up_rounded,
                      iconBgColor: const Color(0xFFE8A020),
                      onTap: () => Get.toNamed(Routes.GAME_FONEM),
                    ),
                    const SizedBox(height: 16),
                    _ExerciseCard(
                      title: 'Rima Kata',
                      subtitle: 'Temukan kata yang berima',
                      icon: Icons.headphones_rounded,
                      iconBgColor: const Color(0xFF7C3AED),
                      onTap: () => Get.toNamed(Routes.GAME_RIMA),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: iconBgColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2977C7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2977C7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A5EA0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2977C7),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'Mulai',
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
    );
  }
}
