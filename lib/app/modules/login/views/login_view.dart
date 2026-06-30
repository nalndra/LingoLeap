import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;
  final LoginController _c = Get.find<LoginController>();

  static const _red    = Color(0xFFE53935);
  static const _green  = Color(0xFF3DAA4C);
  static const _border = Color(0xFFCCCCCC);
  static const _navy   = Color(0xFF1A3A6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Image.asset(
                'assets/auth/lingoleapGreen.png',
                height: 150,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 150,
                  child: Center(
                    child: Icon(Icons.language, size: 90, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat datang, Pahlawan!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Gunakan kunci rahasiamu untuk\nmembuka pintu petualangan!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.5),
              ),
              const SizedBox(height: 28),

              // ─── Form Card ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _green,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    _buildLabel('Email Pahlawan'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTextField(
                          controller: _c.emailController,
                          hint: 'Masukan Emailmu, Pahlawan.',
                          keyboardType: TextInputType.emailAddress,
                          errorText: _c.emailError.value,
                        )),
                    const SizedBox(height: 16),

                    // Password
                    _buildLabel('Kunci Rahasia'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTextField(
                          controller: _c.passwordController,
                          hint: 'Masukan kunci rahasiamu!',
                          obscure: _obscurePassword,
                          errorText: _c.passError.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        )),
                    const SizedBox(height: 8),

                    // Lupa password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Lupa Kunci Rahasia?',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                _c.isLoading.value ? null : () => _c.login(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              elevation: 0,
                            ),
                            child: _c.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Lanjutkan Petualangan',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Baru di sini?',
                style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE233),
                    foregroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Buat Akun Pahlawan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.toNamed('/parent-login'),
                child: Text(
                  'Masuk sebagai Orang Tua',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A)),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String errorText = '',
  }) {
    final hasError = errorText.isNotEmpty;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        suffixIcon: suffixIcon,
        errorText: hasError ? errorText : null,
        errorStyle: const TextStyle(fontSize: 12, color: _red),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: hasError ? _red : _border,
            width: hasError ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: hasError ? _red : _green,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: _red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: _red, width: 1.5),
        ),
        filled: false,
      ),
    );
  }

}
