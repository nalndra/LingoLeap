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
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Diubah jadi start agar mulai dari atas
                children: [
                  // UBAH ANGKA INI UNTUK MENGGESER HEADER (JUDUL & BACK) KE ATAS ATAU KE BAWAH
                  const SizedBox(height: 15), 

                  // Custom Header
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: Color(0xFF005DA7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Image.asset('assets/icons/back.png', width: 22, height: 22, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Buat PIN Orang Tua',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 31.2 / 24,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 46),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Buat 4 digit PIN agar area laporan dan pengaturan\ntetap aman dari si kecil.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 56),
                  const PinPad(),
                  const SizedBox(height: 40), // Give some bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
