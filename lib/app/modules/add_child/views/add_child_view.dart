import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/add_child_controller.dart';

class AddChildView extends GetView<AddChildController> {
  const AddChildView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAED), // Soft yellow background
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              'Tambah Anak',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF4CAF50), // Green title
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
                  const SizedBox(height: 32),

                  // Subtitle
                  Text(
                    'Hubungkan akun LingoLeap si kecil ke Dasbor Ayah/Bunda. Masukkan email dan nama panggilan anak yang sudah terdaftar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // White Card Form
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          'Email Akun anak',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Masukan email Anak',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Color(0xFF005DA7), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name Field
                        Text(
                          'Nama Pahlawan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            hintText: 'Masukan nama pahlawan',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Color(0xFF005DA7), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Submit Button
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value ? null : () => controller.findAndLinkChild(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005DA7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Lanjut',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
