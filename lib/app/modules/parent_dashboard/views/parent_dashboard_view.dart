import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/parent_dashboard_controller.dart';

class ParentDashboardView extends GetView<ParentDashboardController> {
  const ParentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2E8), // Warm beige background
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Profile
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3DAA4C), // Green
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.parentName.value,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF005A9C), // Blue
                            ),
                          ),
                          Text(
                            controller.parentEmail.value,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF005A9C).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF005A9C), // Blue
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/settings.png', 
                          color: Colors.white,
                          width: 20,
                          height: 20,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.settings, color: Colors.white, size: 20),
                        ),
                        onPressed: () => Get.toNamed('/parent-settings'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. Card 1: Progress Belajar Anak
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 0, // Solid bottom shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDot(true),
                          _buildDot(false),
                          _buildDot(false),
                          _buildDot(false),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Progress Belajar Anak',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF005A9C),
                        ),
                      ),
                      Text(
                        'Suku Kata',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF005A9C),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Circular Progress
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: controller.sukuKataProgress.value / 100,
                                strokeWidth: 24,
                                backgroundColor: const Color(0xFF005A9C).withOpacity(0.15),
                                color: const Color(0xFF005A9C),
                                strokeCap: StrokeCap.round, // Not officially supported out-of-box for circular, but good to specify
                              ),
                            ),
                            Text(
                              '${controller.sukuKataProgress.value}%',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF005A9C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Geser untuk melihat yang lainya!',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Card 2: Statistik Performa Anak
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Statistik Performa Anak',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF005A9C),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLinearStat('Fokus Anak', controller.fokusAnak.value, const Color(0xFF005A9C)),
                      const SizedBox(height: 16),
                      _buildLinearStat('Kecepatan Membaca', controller.kecepatanMembaca.value, const Color(0xFFF07B26)),
                      const SizedBox(height: 16),
                      _buildLinearStat('Pengenalan Huruf', controller.pengenalanHuruf.value, const Color(0xFF3DAA4C)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Card 3: Kata Kata Sulit Anak
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Kata Kata Sulit Anak',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF005A9C),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3, // Adjust height
                        ),
                        itemCount: controller.kataSulit.length,
                        itemBuilder: (context, index) {
                          final item = controller.kataSulit[index];
                          return _buildWordCard(item['word'], item['count']);
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                    label: Text(
                      'Keluar Akun',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFD32F2F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),

    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF005A9C) : const Color(0xFF005A9C).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLinearStat(String title, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '$value%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 14,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildWordCard(String word, int count) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEB4B4B), // Red
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFFC23A3A), // Darker red for 3D effect
                  width: 4,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              word,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mengulang ${count}x',
          style: GoogleFonts.poppins(
            color: const Color(0xFFEB4B4B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
