import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/pin_controller.dart';
import 'widgets/pin_pad.dart';

class PinSetupView extends GetView<PinController> {
  const PinSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button — baris sendiri, rata kiri
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFF005DA7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      'assets/icons/back.png',
                      width: 22,
                      height: 22,
                      color: Colors.white,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Judul — berdiri sendiri, pasti di tengah
              Text(
                'Buat PIN Orang Tua',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Buat 4 digit PIN agar area laporan\ndan pengaturan tetap aman dari si kecil.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              const PinPad(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
