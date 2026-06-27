import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../quest/views/quest_view.dart';
import '../../progress/views/progress_view.dart';
import '../../profile/views/profile_view.dart';

// ─── Shell ────────────────────────────────────────────────────────────────────

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF),
      floatingActionButton: Obx(
        () => AnimatedScale(
          scale: controller.tabIndex.value == 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: controller.tabIndex.value == 0
                ? () => Get.toNamed(Routes.CHAT_LIPPO)
                : null,
            backgroundColor: const Color(0xFF3DAA4C),
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.chat_bubble_rounded,
                color: Colors.white, size: 26),
          ),
        ),
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageSwiped,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: const [
          _HomeTab(),
          QuestView(),
          ProgressView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Bottom Nav ───────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Obx(() {
      final idx = controller.tabIndex.value;
      return BottomNavigationBar(
        currentIndex: idx,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3DAA4C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          _navItem(Icons.home_rounded, 'Home', idx == 0),
          _navItem(Icons.explore_outlined, 'Quest', idx == 1),
          _navItem(Icons.bar_chart_rounded, 'Progress', idx == 2),
          _navItem(Icons.person_outline_rounded, 'Hero', idx == 3),
        ],
      );
    });
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, bool active) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFA1FA49) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 26),
      ),
      label: label,
    );
  }
}

// ─── Home Tab Content ─────────────────────────────────────────────────────────

class _HomeTab extends GetView<HomeController> {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildGreeting(),
              const SizedBox(height: 16),
              _buildQuoteBox(),
              const SizedBox(height: 20),
              _buildTutorialCard(),
              const SizedBox(height: 16),
              _buildPetualanganCard(),
              const SizedBox(height: 16),
              _buildLatihanCard(),
              const SizedBox(height: 16),
              _buildDailyMissionCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(
                'assets/icons/profile_avatar.png',
                width: 48,
                height: 48,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DAA4C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.currentUser?.displayName ?? 'Pahlawan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2977C7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite,
                            color: Color(0xFFE53935), size: 15),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Obx(() => Text(
                                '${controller.hearts.value}/5',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE53935),
                                ),
                              )),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.bolt,
                            color: Color(0xFFFFB300), size: 15),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Obx(() => Text(
                                '${controller.xp.value} XP',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFB300),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Obx(() => Image.asset(
              controller.rankBadgeAsset,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8621A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.military_tech_rounded,
                    color: Colors.white, size: 28),
              ),
            )),
      ],
    );
  }

  // ─── Greeting ──────────────────────────────────────────────────────────────

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Pahlawan!',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Siap untuk petualangan bahasa hari ini?\nPilih tantanganmu dan kumpulkan berlian!',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF6B6B6B),
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ─── Quote Box ─────────────────────────────────────────────────────────────

  Widget _buildQuoteBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3DAA4C), width: 1.5),
      ),
      child: Text(
        '"Ayo Selesaikan Tutorial untuk membuka peta baru!"',
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF3DAA4C),
        ),
      ),
    );
  }

  // ─── Tutorial Card ─────────────────────────────────────────────────────────

  Widget _buildTutorialCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A5EA0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2977C7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTag('BELUM SELESAI', const Color(0xFFE53935)),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Mode Tutorial',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pelajari dasar-dasar bahasa dengan cara yang seru dan interaktif!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.3,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFA1FA49)),
              ),
            ),
            const SizedBox(height: 16),
            _buildCardButton(
              label: 'Mulai Belajar',
              onTap: () => Get.toNamed(Routes.TUTORIAL),
              backgroundColor: Colors.white,
              textColor: const Color(0xFF2977C7),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Petualangan Card ──────────────────────────────────────────────────────

  Widget _buildPetualanganCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTag('TERKUNCI', Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            'Mode Petualangan',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Jelajahi dunia fantasi dan gunakan bahasamu untuk melawan monster.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFFAAAAAA),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Icon(Icons.lock_rounded, size: 44, color: Colors.grey[400]),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Selesaikan Tutorial untuk Membuka',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCardButton(
            label: 'Jelajahi Peta',
            onTap: null,
            backgroundColor: Colors.grey.shade300,
            textColor: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }

  // ─── Latihan Card ──────────────────────────────────────────────────────────

  Widget _buildLatihanCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A3D1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E5D30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTag('BEBAS MAIN', const Color(0xFF3DAA4C)),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_esports_rounded,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Mode Latihan',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Latih kosa kata barumu dengan mini-game yang menantang.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 28),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 28),
                Icon(Icons.star_border_rounded,
                    color: Color(0xFFFFD700), size: 28),
              ],
            ),
            const SizedBox(height: 16),
            _buildCardButton(
              label: 'Main Sekarang',
              onTap: () => Get.toNamed(Routes.LATIHAN),
              backgroundColor: const Color(0xFF3DAA4C),
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Daily Mission Card ────────────────────────────────────────────────────

  Widget _buildDailyMissionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5E2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 38)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Misi Harian: Berani Bicara!',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ucapkan 5 kata baru untuk mendapatkan 20 XP tambahan.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '2 / 5 Kata',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 2 / 5,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE8A020)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared Helpers ────────────────────────────────────────────────────────

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCardButton({
    required String label,
    required VoidCallback? onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
