import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_email_controller.dart';

class VerifyEmailView extends GetView<VerifyEmailController> {
  const VerifyEmailView({super.key});

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
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 150,
                  child: Center(
                    child: Icon(Icons.language, size: 90, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verifikasi Emailmu!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A6B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kami sudah mengirim link verifikasi\nke emailmu. Klik link tersebut untuk\nmelanjutkan petualangan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 64,
                      color: Color(0xFF3DAA4C),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cek inbox atau folder Spam/Junk emailmu, lalu klik link verifikasi yang dikirim.\nP.S kemungkinan besar terdapat di bagian SPAM.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xFFF9A825)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Jika masuk spam, klik "Not spam" / "Bukan spam" agar email berikutnya langsung masuk inbox.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF795548),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Halaman ini otomatis lanjut setelah emailmu terverifikasi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.resendEmail,
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
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Kirim Ulang Email',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: controller.backToLogin,
                child: const Text(
                  'Kembali ke Login',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
