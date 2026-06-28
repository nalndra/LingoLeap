import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/pin_controller.dart';
import 'widgets/pin_pad.dart';

class PinConfirmView extends GetView<PinController> {
  const PinConfirmView({super.key});

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
                        decoration: const BoxDecoration(
                          color: Color(0xFF005DA7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                          onPressed: () {
                            controller.currentInput.value = '';
                            Get.back();
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Konfirmasi PIN',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // To balance the back button
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Masukkan ulang PIN yang baru saja\nAnda buat.',
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
                  const SizedBox(height: 40), // Bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
