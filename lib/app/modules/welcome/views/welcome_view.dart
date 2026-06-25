import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _jumpController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animasi slide turun dari atas ke bawah
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeOut),
    );

    // Animasi opacity fade-in
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeIn),
    );

    // Animasi scale grow dari kecil ke normal
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeOut),
    );

    // Mulai animasi
    _jumpController.forward();
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4caf50), // Hijau Material
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top spacing
            const SizedBox(height: 40),

            // Main content - Logo & Title centered
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Falling Mascot/Logo dengan animasi slide, fade, dan scale
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildMascotLogo(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // App Title - LingoLeap
                    Text(
                      'LingoLeap',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Spacing bawah
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotLogo() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Center(
        child: Image.asset(
          'assets/auth/mascot.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
