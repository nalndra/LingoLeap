import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/premium_controller.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  static const _bgColor = Color(0xFFFCFAED);
  static const _blue = Color(0xFF2977C7);
  static const _green = Color(0xFF4CAF50);
  static const _red = Color(0xFFEB4B4B);
  static const _gold = Color(0xFFF5A623);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // ─── Header ───
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: _green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Langganan Premium',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 32),

                // ─── Plan 1: Ksatria Pemula ───
                _buildPlanCard(
                  borderColor: _blue,
                  bgColor: Colors.white,
                  leadingIcon: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.favorite, size: 56, color: _red),
                      const Positioned(
                        child: Icon(Icons.all_inclusive, size: 26, color: Colors.white),
                      ),
                    ],
                  ),
                  title: 'Ksatria Pemula',
                  titleColor: _blue,
                  subtitle: 'Mendapatkan Hati yang tak\nterbatas.',
                  ribbonColor: _red,
                  ribbonDarkColor: const Color(0xFFC23A3A),
                  ribbonText: 'Ksatria Pemula',
                  price: 'Rp 39.000/bulan',
                  buttonColor: const Color(0xFF005DA7),
                  planId: 'pemula',
                ),
                const SizedBox(height: 32),

                _buildPlanCard(
                  borderColor: const Color(0xFFE26C22),
                  bgColor: const Color(0xFFEFCA44),
                  leadingIcon: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/icons/heart_red.png', width: 56, height: 56),
                      Positioned(
                        right: -4,
                        child: Image.asset('assets/icons/plus_circle.png', width: 40, height: 40),
                      ),
                    ],
                  ),
                  topLeftDecor: 'assets/icons/leaf_left.png',
                  topRightDecor: 'assets/icons/leaf_right.png',
                  title: 'Ksatria Kerajaan',
                  titleColor: const Color(0xFFE26C22),
                  subtitle: 'Hati tak terbatas dan\ntambah hingga 3 anak.',
                  ribbonColor: _red,
                  ribbonDarkColor: const Color(0xFFC23A3A),
                  ribbonText: 'Ksatria Kerajaan',
                  price: 'Rp 79.000/bulan',
                  buttonColor: const Color(0xFF005DA7),
                  planId: 'kerajaan',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required Color borderColor,
    required Color bgColor,
    required Widget leadingIcon,
    String? topLeftDecor,
    String? topRightDecor,
    required String title,
    required Color titleColor,
    required String subtitle,
    required Color ribbonColor,
    required Color ribbonDarkColor,
    required String ribbonText,
    required String price,
    required Color buttonColor,
    required String planId,
  }) {
    return Column(
      children: [
        // Main Card
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  SizedBox(
                    width: 72,
                    height: 64,
                    child: leadingIcon,
                  ),
                  const SizedBox(width: 8),
                  // Title + Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (topLeftDecor != null)
              Positioned(
                top: -20,
                left: -10,
                child: Image.asset(topLeftDecor, width: 64),
              ),
            if (topRightDecor != null)
              Positioned(
                top: -20,
                right: -10,
                child: Image.asset(topRightDecor, width: 64),
              ),
          ],
        ),

        // ─── Ribbon Banner ───
        Transform.translate(
          offset: const Offset(0, -18),
          child: SizedBox(
            width: 270,
            height: 54,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left ribbon tail
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.asset('assets/icons/ribbon_left.png', height: 36),
                ),
                // Right ribbon tail
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset('assets/icons/ribbon_right.png', height: 36),
                ),
                // Center ribbon
                Positioned(
                  left: 20,
                  right: 20,
                  top: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/ribbon_center.png',
                        width: double.infinity,
                        height: 44,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        ribbonText,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 4),

        // ─── Price Button ───
        SizedBox(
          width: 220,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              controller.selectPlan(planId);
              controller.subscribe();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: Text(
              price,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
