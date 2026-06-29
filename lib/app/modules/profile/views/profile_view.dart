import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  HomeController get _home => Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
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
                  errorBuilder: (ctx, e, s) => const Icon(
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
          errorBuilder: (ctx, e, s) => const Icon(
            Icons.catching_pokemon_rounded,
            size: 120,
            color: Color(0xFF3DAA4C),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Text(
          _home.childName.value.isEmpty ? 'Pahlawan' : _home.childName.value,
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2977C7),
          ),
        )),
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
