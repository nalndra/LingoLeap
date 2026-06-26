import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Use a dynamic getter to always fetch the active GetX controller instance
  RegisterController get _controller => Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF), // Warm Beige background matching screenshots
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

                  // LingoLeap Green Frog Logo & Title
                  _buildLogoAndTitle(),

                  const SizedBox(height: 16),

                  // Header greeting text
                  Text(
                    'Selamat datang, Pahlawan!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A3A6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gunakan kunci rahasiamu untuk membuka pintu petualangan!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // White Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
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
                            color: const Color(0xFF3DAA4C), // Green heading
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        _buildLabel('Email Pahlawan'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _controller.emailController,
                          hint: 'Masukan Emailmu, Pahlawan.',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Name Field
                        _buildLabel('Nama Pahlawan'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _controller.nameController,
                          hint: 'Siapa namamu, Pahlawan?',
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        _buildLabel('Kunci Rahasia'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _controller.passwordController,
                          hint: 'Masukan Kata kunci pahlawanmu!',
                          obscure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF888888),
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field
                        _buildLabel('Konfirmasi Kunci Rahasia'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _controller.confirmPasswordController,
                          hint: 'Masukan Kata kunci pahlawanmu!',
                          obscure: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF888888),
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Mulai Petualangan (Blue 3D Tactile Button)
                        Obx(
                          () => _buildTactileButton(
                            onPressed: _controller.isLoading.value
                                ? null
                                : () => _controller.register(),
                            color: const Color(0xFF005EA6), // Blue matching screenshot
                            shadowColor: const Color(0xFF00447A),
                            child: _controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Mulai Petualangan',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom CTA: Sudah punya akun? Masuk Akun Pahlawan
                  Text(
                    'Sudah punya akun?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Masuk Akun Pahlawan (Green 3D Tactile Button)
                  _buildTactileButton(
                    onPressed: () => Get.back(),
                    color: const Color(0xFF9AE233), // Lime green matching screenshot
                    shadowColor: const Color(0xFF71A919),
                    child: Text(
                      'Masuk Akun Pahlawan',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A3A6B), // Blue text
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

  Widget _buildLogoAndTitle() {
    return Column(
      children: [
        // Green frog logo representation
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Image.asset(
            'assets/auth/lingoleapGreen.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DAA4C), // Frog green
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.language_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'LingoLeap',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF3DAA4C), // Green text logo
            letterSpacing: -0.5,
          ),
        ),
      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
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
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBDC5D1), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3DAA4C), width: 1.8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildTactileButton({
    required VoidCallback? onPressed,
    required Color color,
    required Color shadowColor,
    required Widget child,
    double height = 50,
  }) {
    final bool isDisabled = onPressed == null;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey[300] : shadowColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: isDisabled ? 0 : 4),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[400] : color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
