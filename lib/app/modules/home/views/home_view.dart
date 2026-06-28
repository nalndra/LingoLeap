import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/header.dart';
import '../../quest/views/quest_view.dart';
import '../../progress/views/progress_view.dart';
import '../../profile/views/profile_view.dart';

// ─── Shell ────────────────────────────────────────────────────────────────────

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: const AppHeader(),
            ),
            Expanded(
              child: PageView(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends GetView<HomeController> {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final idx = controller.tabIndex.value;
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: idx == 0,
                  onTap: () => controller.changeTab(0),
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  label: 'Quest',
                  active: idx == 1,
                  onTap: () => controller.changeTab(1),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Progress',
                  active: idx == 2,
                  onTap: () => controller.changeTab(2),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Hero',
                  active: idx == 3,
                  onTap: () => controller.changeTab(3),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF4CAF50) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 26,
              color: active ? Colors.white : const Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends GetView<HomeController> {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildTutorialCard(),
            const SizedBox(height: 16),
            _buildPetualanganCard(),
            const SizedBox(height: 16),
            _buildLatihanCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Tutorial Card ─────────────────────────────────────────────────────────

  Widget _buildTutorialCard() {
    return _MenuCard(
      title: 'Tutorial',
      subtitle: 'Belajar cara bermain',
      icon: Icons.explore_rounded,
      cardColor: const Color(0xFF4CAF50),
      shadowColor: const Color(0xFF338A3E),
      iconColor: const Color(0xFF4CAF50),
      buttonLabel: 'Mulai',
      onTap: () => Get.toNamed(Routes.TUTORIAL),
    );
  }

  // ─── Petualangan Card ──────────────────────────────────────────────────────

  Widget _buildPetualanganCard() {
    return _MenuCard(
      title: 'Petualangan',
      subtitle: 'Jelajahi peta dan\ndapatkan hadiah',
      icon: Icons.map_outlined,
      cardColor: const Color(0xFFE8621A),
      shadowColor: const Color(0xFFBF4D10),
      iconColor: const Color(0xFFE8621A),
      buttonLabel: 'Jelajahi!',
      onTap: () => Get.toNamed(Routes.QUEST),
    );
  }

  // ─── Latihan Card ──────────────────────────────────────────────────────────

  Widget _buildLatihanCard() {
    return _MenuCard(
      title: 'Latihan',
      subtitle: 'Latih kekuatan\npahlawan',
      icon: Icons.sports_martial_arts_rounded,
      cardColor: const Color(0xFF4A5CE8),
      shadowColor: const Color(0xFF3040C0),
      iconColor: const Color(0xFF4A5CE8),
      buttonLabel: 'Latihan!',
      onTap: () => Get.toNamed(Routes.LATIHAN),
    );
  }
}

// ─── Reusable Menu Card ────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.shadowColor,
    required this.iconColor,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color shadowColor;
  final Color iconColor;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: shadowColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon in white rounded square
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 42),
                ),
                const SizedBox(width: 18),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Button with 3D effect
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A5EA0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2977C7),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
