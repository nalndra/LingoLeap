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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF0ECD8),
                child: _buildMapArea(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
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
                  color: controller.selectedIndex.value == 0
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    'assets/icons/map.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 1
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    'assets/icons/quest.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              label: 'Quest',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 2
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    'assets/icons/progress.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 3
                      ? const Color(0xFFA1FA49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Transform.scale(
                  scale: 2.0,
                  child: Image.asset(
                    'assets/icons/hero.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              label: 'Hero',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFFFAF9EF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Avatar
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
                        color: const Color(0xFF1A3A6B),
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
          // Right Avatar
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

  Widget _buildMapArea() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            // Row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(0),
                _buildHorizontalDashedLine(),
                _buildNode(1),
              ],
            ),
            _buildVerticalDashedLine(isRight: true),
            // Row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(3),
                _buildHorizontalDashedLine(),
                _buildNode(2),
              ],
            ),
            _buildVerticalDashedLine(isRight: false),
            // Row 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(4),
                _buildHorizontalDashedLine(),
                _buildNode(5),
              ],
            ),
            _buildVerticalDashedLine(isRight: true),
            // Row 4
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

    final Color bgColor = unlocked ? const Color(0xFF005A9C) : const Color(0xFFBFC4C9);
    final Color shadowColor = unlocked ? const Color(0xFF003A7C) : const Color(0xFF9AA0A6);

    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: shadowColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          )
        ],
      ),
      child: icon is IconData
          ? Icon(
              icon,
              color: Colors.white,
              size: 44,
            )
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
