import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF),
      body: SafeArea(
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageSwiped,
          physics: const ClampingScrollPhysics(),
          children: [
            _buildMapPage(),
            _buildComingSoon('Quest'),
            _buildProgressPage(),
            _buildHeroPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3DAA4C),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.tabIndex.value == 0
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.map_outlined, size: 26),
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.tabIndex.value == 1
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.explore_outlined, size: 26),
              ),
              label: 'Quest',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.tabIndex.value == 2
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.bar_chart_rounded, size: 26),
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.tabIndex.value == 3
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_outline_rounded, size: 26),
              ),
              label: 'Hero',
            ),
          ],
        ),
      ),
    );
  }

  // ─── Map Page ────────────────────────────────────────────────────────────────

  Widget _buildMapPage() {
    return Column(
      children: [
        _buildMapHeader(),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF0ECD8),
            child: _buildMapArea(),
          ),
        ),
      ],
    );
  }

  Widget _buildMapHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFFFAF9EF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/profile_avatar.png',
                  width: 48,
                  height: 48,
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
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Color(0xFFE53935), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '5/5',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE53935),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, color: Color(0xFFFFB300), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '100 XP',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFB300),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.logout(),
            child: Image.asset(
              'assets/icons/rank_badge.png',
              width: 48,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero / Profile Page ─────────────────────────────────────────────────────

  Widget _buildHeroPage() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildHeroHeader() {
    return Row(
      children: [
        // Avatar — frog image, no background
        Image.asset(
          'assets/profile/frog_icon.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF3DAA4C),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        // Name + stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.currentUser?.displayName ?? 'Pahlawan',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2977C7),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFE53935), size: 15),
                  const SizedBox(width: 3),
                  Obx(() => Text(
                    '${controller.hearts.value}/5',
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
                    '${controller.xp.value} XP',
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
        // Rank badge — matches current rank
        Obx(() => Image.asset(
          controller.rankBadgeAsset,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.military_tech_rounded,
            size: 40,
            color: Color(0xFFCD7F32),
          ),
        )),
        const SizedBox(width: 10),
        // Settings button
        GestureDetector(
          onTap: () => _showSettingsMenu(),
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
            child: const Icon(Icons.settings_rounded, color: Colors.white, size: 26),
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
          // Left — badge, full image, no clipping or decoration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              controller.rankBadgeAsset,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.military_tech_rounded,
                size: 64,
                color: Color(0xFFCD7F32),
              ),
            ),
          ),
          // Right — rank text only
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
                  controller.rankName,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: controller.rankColor,
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
          errorBuilder: (_, _, _) => const Icon(
            Icons.catching_pokemon_rounded,
            size: 120,
            color: Color(0xFF3DAA4C),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          controller.currentUser?.displayName ?? 'Pahlawan',
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
                value: '${controller.streak.value}',
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
                value: '${controller.level.value}',
                icon: null,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value, String? icon}) {
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
      _BadgeData(label: '5+', color: const Color(0xFFE8621A), icon: Icons.local_fire_department_rounded, locked: false),
      _BadgeData(label: '', color: const Color(0xFF7C3AED), icon: Icons.explore_rounded, locked: false),
      _BadgeData(label: '', color: const Color(0xFFB45309), icon: Icons.extension_rounded, locked: false),
      _BadgeData(label: '?', color: Colors.grey[350]!, icon: null, locked: true),
      _BadgeData(label: '?', color: Colors.grey[350]!, icon: null, locked: true),
      _BadgeData(label: '?', color: Colors.grey[350]!, icon: null, locked: true),
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
                controller.logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Progress Page ────────────────────────────────────────────────────────────

  Widget _buildProgressPage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildHeroHeader(),
            const SizedBox(height: 20),
            _buildLevelCard(),
            const SizedBox(height: 16),
            _buildStatisticCard(),
            const SizedBox(height: 16),
            _buildQuestJourneyCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard() {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3DAA4C),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2977C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Level ${controller.level.value}',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Image.asset(
                'assets/profile/frog_icon.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.catching_pokemon_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Pahlawan Pengetahuan',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Level',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${controller.xp.value}/1000 XP',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (controller.xp.value / 1000).clamp(0.0, 1.0),
              minHeight: 14,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A3A6B)),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildStatisticCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Statistik Pahlawan',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2977C7),
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow('Fokus', 0.50, const Color(0xFF2977C7)),
          const SizedBox(height: 16),
          _buildStatRow('Kecepatan Pengerjaan', 0.76, const Color(0xFFE8621A)),
          const SizedBox(height: 16),
          _buildStatRow('Ketelitian', 0.85, const Color(0xFF3DAA4C)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, double value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestJourneyCard() {
    final quests = [
      _QuestStep(label: 'Suku Kata', icon: Icons.text_fields_rounded, done: true),
      _QuestStep(label: 'KosaKata', icon: Icons.menu_book_rounded, done: false),
      _QuestStep(label: 'Fonem Kata', icon: Icons.volume_up_rounded, done: false),
      _QuestStep(label: 'Rima kata', icon: Icons.headphones_rounded, done: false),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Perjalanan Quest',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2977C7),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(quests.length, (i) {
              final q = quests[i];
              final isLast = i == quests.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          // Circle node
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: q.done
                                  ? const Color(0xFF3DAA4C)
                                  : Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              q.done ? Icons.check_rounded : q.icon,
                              color: q.done ? Colors.white : Colors.grey[500],
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            q.label,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: q.done
                                  ? const Color(0xFF3DAA4C)
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Connector line (not after last)
                    if (!isLast)
                      Container(
                        width: 20,
                        height: 2,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 28),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── Coming Soon Placeholder ─────────────────────────────────────────────────

  Widget _buildComingSoon(String name) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.construction_rounded, size: 64, color: Color(0xFFBBBBBB)),
          const SizedBox(height: 16),
          Text(
            '$name\nSegera Hadir!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFAAAAAA),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Map Page Widgets ─────────────────────────────────────────────────────────

  Widget _buildMapArea() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(0),
                _buildHorizontalDashedLine(),
                _buildNode(1),
              ],
            ),
            _buildVerticalDashedLine(isRight: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(3),
                _buildHorizontalDashedLine(),
                _buildNode(2),
              ],
            ),
            _buildVerticalDashedLine(isRight: false),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(4),
                _buildHorizontalDashedLine(),
                _buildNode(5),
              ],
            ),
            _buildVerticalDashedLine(isRight: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(7),
                _buildHorizontalDashedLine(),
                _buildNode(6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode(int index) {
    if (index >= controller.levels.length) return const SizedBox();
    final level = controller.levels[index];
    final bool unlocked = level['unlocked'];
    final dynamic icon = level['icon'];

    final Color bgColor = unlocked ? const Color(0xFF2977C7) : const Color(0xFFBFC4C9);
    final Color shadowColor = unlocked ? const Color(0xFF1A5EA0) : const Color(0xFF9AA0A6);

    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: shadowColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          )
        ],
      ),
      child: icon is IconData
          ? Icon(icon, color: Colors.white, size: 44)
          : Center(
              child: Transform.scale(
                scale: 2.0,
                child: Image.asset(
                  icon,
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  Widget _buildHorizontalDashedLine() {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (_) {
          return Container(
            width: 14,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFDCDEDF),
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerticalDashedLine({required bool isRight}) {
    return Transform.translate(
      offset: Offset(isRight ? 86 : -86, 0),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (_) {
            return Container(
              width: 10,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFDCDEDF),
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
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

class _QuestStep {
  final String label;
  final IconData icon;
  final bool done;
  const _QuestStep({
    required this.label,
    required this.icon,
    required this.done,
  });
}
