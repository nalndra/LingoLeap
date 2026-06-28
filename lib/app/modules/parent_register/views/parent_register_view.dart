import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/parent_register_controller.dart';

class ParentRegisterView extends GetView<ParentRegisterController> {
  const ParentRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF), // Match child register
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  
                  // Logo
                  Image.asset('assets/auth/lingoleapGreen.png', height: 100, fit: BoxFit.contain),

                  const SizedBox(height: 16),

                  Text(
                    'Selamat datang, Ayah dan Bunda!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A3A6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gunakan kata sandi untuk membuka pintu\npetualangan dan memantau kegiatan anak!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3DAA4C),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildLabel('Email Orang Tua'),
                        const SizedBox(height: 8),
                        _buildTextField(controller.emailController, 'Masukan Email Orang tua', TextInputType.emailAddress),
                        
                        const SizedBox(height: 16),
                        
                        _buildLabel('Nama Orang Tua'),
                        const SizedBox(height: 8),
                        _buildTextField(controller.nameController, 'Masukan nama Orang tua', TextInputType.text),
                        
                        const SizedBox(height: 16),
                        
                        _buildLabel('Kata Sandi'),
                        const SizedBox(height: 8),
                        Obx(() => _buildTextField(
                          controller.passwordController, 
                          'Masukan Kata sandi', 
                          TextInputType.text, 
                          isPassword: true,
                          obscure: controller.obscurePassword.value,
                          onToggleVisibility: controller.toggleObscurePassword,
                        )),
                        
                        const SizedBox(height: 16),
                        
                        _buildLabel('Konfirmasi Kata Sandi'),
                        const SizedBox(height: 8),
                        Obx(() => _buildTextField(
                          controller.confirmPasswordController, 
                          'Ulangi Kata sandi', 
                          TextInputType.text, 
                          isPassword: true,
                          obscure: controller.obscureConfirmPassword.value,
                          onToggleVisibility: controller.toggleObscureConfirmPassword,
                        )),
                        
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A3A6B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Buat Akun',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Sudah punya akun?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9AE233),
                        foregroundColor: const Color(0xFF1A3A6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Masuk Akun Orang Tua',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.offNamed('/login'),
                    child: Text(
                      'Kembali ke Log In Anak',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A3A6B),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A3A6B),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String hint, TextInputType keyboardType, {bool isPassword = false, bool obscure = false, VoidCallback? onToggleVisibility}) {
    return TextField(
      controller: textController,
      keyboardType: keyboardType,
      obscureText: isPassword ? obscure : false,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: const Color(0xFF1A1A1A),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFAAAAAA),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBDC5D1), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3DAA4C), width: 1.8),
        ),
      ),
    );
  }
}
