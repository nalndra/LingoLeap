import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/parent_login_controller.dart';

class ParentLoginView extends StatefulWidget {
  const ParentLoginView({super.key});

  @override
  State<ParentLoginView> createState() => _ParentLoginViewState();
}

class _ParentLoginViewState extends State<ParentLoginView> {
  final ParentLoginController _c = Get.find<ParentLoginController>();

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
                'Selamat datang, Ayah & Bunda!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masuk untuk memantau perkembangan\npetualangan buah hatimu!',
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
                    _buildLabel('Email Orang Tua'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTextField(
                          controller: _c.emailController,
                          hint: 'Masukan Email Orang Tua',
                          keyboardType: TextInputType.emailAddress,
                          errorText: _c.emailError.value,
                        )),
                    const SizedBox(height: 16),

                    // Password
                    _buildLabel('Kata Sandi'),
                    const SizedBox(height: 8),
                    Obx(() => _buildTextField(
                          controller: _c.passwordController,
                          hint: 'Masukan kata sandi',
                          obscure: _c.obscurePassword.value,
                          errorText: _c.passError.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _c.obscurePassword.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: _c.toggleObscure,
                          ),
                        )),
                    const SizedBox(height: 8),

                    // Lupa kata sandi
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Server error
                    Obx(() {
                      final err = _c.serverError.value;
                      if (err.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildErrorBox(err),
                      );
                    }),

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
                                    'Masuk Dashboard',
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
                  onPressed: () => Get.toNamed('/parent-register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE233),
                    foregroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Buat Akun Orang Tua',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Kembali ke Log In Anak',
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

  // ─── Helpers ──────────────────────────────────────────────────────────────────

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

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _red, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: _red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: _red, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController();
    final sending   = false.obs;
    final sent      = false.obs;

    Get.dialog(
      Obx(() => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            title: const Text(
              'Reset Kata Sandi',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: _navy, fontSize: 18),
            ),
            content: sent.value
                ? const Row(
                    children: [
                      Icon(Icons.check_circle, color: _green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tautan reset dikirim. Cek inbox emailmu!',
                          style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Masukkan email terdaftar. Kami akan mengirimkan tautan reset kata sandi.',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF555555)),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'email@contoh.com',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(
                                color: _border, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(
                                color: _green, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
            actions: sent.value
                ? [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: sending.value
                          ? null
                          : () async {
                              final email = emailCtrl.text.trim();
                              if (email.isEmpty) return;
                              sending.value = true;
                              try {
                                await _c.sendResetEmail(email);
                                sent.value = true;
                              } catch (_) {} finally {
                                sending.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        elevation: 0,
                      ),
                      child: sending.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Kirim',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
          )),
    );
  }
}
