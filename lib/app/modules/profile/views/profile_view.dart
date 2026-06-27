import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  HomeController get _home => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _buildHeroHeader(),
                const SizedBox(height: 20),
                _buildRankingCard(),
                const SizedBox(height: 24),
                _buildMascotArea(),
                const SizedBox(height: 24),
                _buildStatsCard(),
                const SizedBox(height: 16),
                _buildBadgeCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offNamed(Routes.HOME);
            break;
          case 1:
            Get.offNamed(Routes.QUEST);
            break;
          case 2:
            Get.offNamed(Routes.PROGRESS);
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
        _navItem(Icons.explore_outlined, 'Quest', false),
        _navItem(Icons.bar_chart_rounded, 'Progress', false),
        _navItem(Icons.person_outline_rounded, 'Hero', true),
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

  Widget _buildHeroHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/profile/frog_icon.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF3DAA4C),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _home.currentUser?.displayName ?? 'Pahlawan',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2977C7),
                ),
              ),
              const SizedBox(height: 3),
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
                  const Icon(Icons.bolt, color: Color(0xFFFFB300), size: 15),
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
        Obx(() => Image.asset(
              _home.rankBadgeAsset,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.military_tech_rounded,
                size: 40,
                color: Color(0xFFCD7F32),
              ),
            )),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _showSettingsMenu,
          child: Container(
            width: 48,
            height: 48,
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
            child:
                const Icon(Icons.settings_rounded, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingCard() {
    return Obx(() => Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  _home.rankBadgeAsset,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.military_tech_rounded,
                    size: 64,
                    color: Color(0xFFCD7F32),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peringkat kamu saat ini:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF2977C7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _home.rankName,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _home.rankColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ));
  }

  Widget _buildMascotArea() {
    return Column(
      children: [
        Image.asset(
          'assets/profile/frog_icon.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.catching_pokemon_rounded,
            size: 120,
            color: Color(0xFF3DAA4C),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _home.currentUser?.displayName ?? 'Pahlawan',
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2977C7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Obx(() => _buildStatItem(
                    label: 'Beruntun',
                    value: '${_home.streak.value}',
                    icon: '🔥',
                  )),
            ),
            VerticalDivider(
              thickness: 1.5,
              color: Colors.grey[200],
              indent: 4,
              endIndent: 4,
            ),
            Expanded(
              child: Obx(() => _buildStatItem(
                    label: 'Lvl',
                    value: '${_home.level.value}',
                    icon: null,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      {required String label, required String value, String? icon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2977C7),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2977C7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgeCard() {
    final badges = [
      _BadgeData(
          label: '5+',
          color: const Color(0xFFE8621A),
          icon: Icons.local_fire_department_rounded,
          locked: false),
      _BadgeData(
          label: '',
          color: const Color(0xFF7C3AED),
          icon: Icons.explore_rounded,
          locked: false),
      _BadgeData(
          label: '',
          color: const Color(0xFFB45309),
          icon: Icons.extension_rounded,
          locked: false),
      _BadgeData(
          label: '?', color: Colors.grey[350]!, icon: null, locked: true),
      _BadgeData(
          label: '?', color: Colors.grey[350]!, icon: null, locked: true),
      _BadgeData(
          label: '?', color: Colors.grey[350]!, icon: null, locked: true),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Koleksi Badge',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2977C7),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: badges.take(3).map(_buildBadge).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: badges.skip(3).map(_buildBadge).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(_BadgeData badge) {
    if (badge.locked) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: badge.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[400]!,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Center(
          child: Text(
            '?',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: badge.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badge.color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: badge.label.isNotEmpty
            ? Text(
                badge.label,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              )
            : Icon(badge.icon, color: Colors.white, size: 34),
      ),
    );
  }

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

class _BadgeData {
  final String label;
  final Color color;
  final IconData? icon;
  final bool locked;
  const _BadgeData({
    required this.label,
    required this.color,
    required this.icon,
    required this.locked,
  });
}
