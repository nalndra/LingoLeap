import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/quest_controller.dart';
import '../../../routes/app_pages.dart';

class QuestView extends GetView<QuestController> {
  const QuestView({super.key});

  HomeController get _home => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildFrogBanner(),
                const SizedBox(height: 40),
                _buildQuestCard(),
                const SizedBox(height: 24),
                _buildContinueButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

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
                      _home.currentUser?.displayName ?? 'Pahlawan',
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
                        Obx(() => Text(
                              '${_home.hearts.value}/5',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE53935),
                              ),
                            )),
                        const SizedBox(width: 10),
                        const Icon(Icons.bolt,
                            color: Color(0xFFFFB300), size: 15),
                        const SizedBox(width: 3),
                        Obx(() => Text(
                              '${_home.xp.value} XP',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFB300),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => Image.asset(
              _home.rankBadgeAsset,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8621A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.military_tech_rounded,
                    color: Colors.white, size: 24),
              ),
            )),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _showSettingsMenu,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF2977C7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2977C7).withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.settings_rounded,
                color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  // ─── Frog Banner ─────────────────────────────────────────────────────────────

  Widget _buildFrogBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/quest/frog_waterfall.png',
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/profile/frog_icon.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quest Card ───────────────────────────────────────────────────────────────

  Widget _buildQuestCard() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Card body — top padding leaves room for the overlapping circle
        Container(
          margin: const EdgeInsets.only(top: 36),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Susun Kata',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF3DAA4C),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.flag_rounded,
                      color: Color(0xFF2977C7), size: 22),
                  Expanded(
                    child: Center(
                      child: Text(
                        '50%',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2977C7),
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.card_giftcard_rounded,
                      color: Color(0xFF2977C7), size: 22),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 12,
                  backgroundColor: Color(0xFFDDE8F5),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2977C7)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite,
                      color: Color(0xFFE53935), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '+1',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.bolt, color: Color(0xFFFFB300), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '+50 XP',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Overlapping circle icon sitting on top edge of card
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF3DAA4C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3DAA4C).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.extension_rounded,
              color: Colors.white, size: 36),
        ),
      ],
    );
  }

  // ─── Continue Button ─────────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F2342),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Material(
          color: const Color(0xFF1A3A6B),
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Lanjutkan Petualangan',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
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

  // ─── Bottom Nav ───────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offNamed(Routes.HOME);
            break;
          case 2:
            Get.offNamed(Routes.PROGRESS);
            break;
          case 3:
            Get.offNamed(Routes.PROFILE);
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3DAA4C),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        _navItem(Icons.home_rounded, 'Home', false),
        _navItem(Icons.explore_outlined, 'Quest', true),
        _navItem(Icons.bar_chart_rounded, 'Progress', false),
        _navItem(Icons.person_outline_rounded, 'Hero', false),
      ],
    );
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

  // ─── Settings Sheet ───────────────────────────────────────────────────────────

  void _showSettingsMenu() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pengaturan',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2977C7),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: Text(
                'Keluar',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Get.back();
                _home.logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
