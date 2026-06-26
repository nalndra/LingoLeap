import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF), // Warm Beige background matching screenshots
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Obx(() {
              return Column(
                children: [
                  // Top Stats Header (shared across tabs)
                  _buildStatsHeader(context),
                  
                  // Body content based on tab
                  Expanded(
                    child: IndexedStack(
                      index: controller.tabIndex.value,
                      children: [
                        _buildHomeTab(context),       // Screen 1
                        _buildQuestTab(context),      // Screen 2
                        _buildProgressTab(context),   // Screen 3
                        _buildHeroTab(context),       // Profile/Hero Tab
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),

          // Full-screen Quiz Overlay
          Obx(() {
            if (controller.isQuizActive.value) {
              return _buildQuizOverlay(context);
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return _buildBottomNavBar();
      }),
    );
  }

  // --- TOP STATS HEADER ---
  Widget _buildStatsHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: const Color(0xFFFAF9EF),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E2E2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Green Profile Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3DAA4C), // Green base
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // White outer circle for person icon
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.currentUser?.displayName ?? 'Nalendra',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: Colors.red, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          '${controller.hearts.value}/5',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          '${controller.xp.value} XP',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Orange circular avatar
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFD67D3E), // Orange bg
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🐻', // Bear/fox emoji
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E2E2), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(0, Icons.home_rounded, 'Home'),
          _buildNavBarItem(1, Icons.explore_rounded, 'Quest'),
          _buildNavBarItem(2, Icons.bar_chart_rounded, 'Progress'),
          _buildNavBarItem(3, Icons.person_rounded, 'Hero'),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isSelected = controller.tabIndex.value == index;
    final activeColor = const Color(0xFF3DAA4C);
    
    return InkWell(
      onTap: () => controller.changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF9AE233).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isSelected ? activeColor : Colors.grey[500],
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
              color: isSelected ? activeColor : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 0: HOME HUB (Screen 1) ---
  Widget _buildHomeTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Headers
          Text(
            'Halo, Pahlawan!',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A3A6B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Siap untuk petualangan bahasa hari ini? Pilih tantanganmu dan kumpulkan berlian!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF555555),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),

          // Recommendations Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF3DAA4C), width: 1.5),
            ),
            child: Center(
              child: Text(
                '“Ayo Selesaikan Tutorial untuk membuka peta baru!”',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF2A7C36),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Cards List
          // 1. Mode Tutorial
          _build3DModeCard(
            title: 'Mode Tutorial',
            desc: 'Pelajari dasar-dasar bahasa dengan cara yang seru dan interaktif!',
            badgeText: 'BELUM SELESAI',
            badgeBgColor: const Color(0xFFE53935), // Red
            cardBgColor: const Color(0xFF2196F3), // Blue base
            shadowColor: const Color(0xFF1565C0),
            icon: Icons.school_rounded,
            actionText: 'Mulai Belajar',
            onTap: () {
              controller.changeTab(1); // Redirects to Quest Tab
            },
            extraWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.35,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9AE233)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Mode Petualangan (Locked)
          _buildLockedModeCard(),

          const SizedBox(height: 20),

          // 3. Mode Latihan
          _build3DModeCard(
            title: 'Mode Latihan',
            desc: 'Latih kosa kata barumu dengan mini-game yang menantang.',
            badgeText: 'BEBAS MAIN',
            badgeBgColor: const Color(0xFF9AE233), // Lime green
            cardBgColor: const Color(0xFF3DAA4C), // Green base
            shadowColor: const Color(0xFF2A7C36),
            icon: Icons.sports_esports_rounded,
            actionText: 'Main Sekarang',
            onTap: () {
              controller.changeTab(2); // Redirects to Progress Tab
            },
            extraWidget: Row(
              children: [
                const SizedBox(height: 24),
                const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                Icon(Icons.star_outline_rounded, color: Colors.white.withOpacity(0.5), size: 18),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Daily Mission (Misi Harian)
          _buildDailyMissionCard(),
        ],
      ),
    );
  }

  // --- TAB 1: QUEST MAP (Screen 2) ---
  Widget _buildQuestTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Frog character and Speech bubble
          _buildFrogMascot('Halo Nalendra! Mari kita latihan dulu agar Strike kamu tetap menyala'),
          
          const SizedBox(height: 12),
          
          Text(
            'Nalendra',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A3A6B),
            ),
          ),

          const SizedBox(height: 12),

          // Stats box
          _buildMascotStatsBox(),

          const SizedBox(height: 24),

          // Exercises List
          Column(
            children: List.generate(controller.exercises.length, (index) {
              final ex = controller.exercises[index];
              return _buildExerciseRowCard(ex);
            }),
          ),

          const SizedBox(height: 20),

          // Bottom "Mulai Belajar" Button
          _buildTactile3DButton(
            onPressed: () {
              // Starts the active/unlocked visual puzzle exercise
              final activeEx = controller.exercises.firstWhereOrNull((ex) => ex.status.value == 'active');
              if (activeEx != null) {
                controller.startQuiz(activeEx.title, activeEx.questions);
              }
            },
            text: 'Mulai Belajar →',
            color: const Color(0xFF9AE233),
            shadowColor: const Color(0xFF71A919),
            textColor: const Color(0xFF1A3A6B),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- TAB 2: PROGRESS/GAMES (Screen 3) ---
  Widget _buildProgressTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Frog mascot and Speech bubble
          _buildFrogMascot('Ayo latihan! semakin banyak berlatih, semakin kuat literasimu'),
          
          const SizedBox(height: 12),
          
          Text(
            'Nalendra',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A3A6B),
            ),
          ),

          const SizedBox(height: 12),

          // Stats box
          _buildMascotStatsBox(),

          const SizedBox(height: 24),

          // Games Grid/List
          Column(
            children: List.generate(controller.games.length, (index) {
              final game = controller.games[index];
              return _buildGameRowCard(game);
            }),
          ),

          const SizedBox(height: 20),

          // Bottom Info Banner Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0079C1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh Tantangan Lebih?',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selesaikan semua level Mudah untuk membuka Area Hutan Kata yang misterius!',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9AE233)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '65%',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- TAB 3: PROFILE / HERO TAB ---
  Widget _buildHeroTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // User Details Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A3A6B),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (controller.currentUser?.displayName?.isNotEmpty ?? false)
                          ? controller.currentUser!.displayName![0].toUpperCase()
                          : 'N',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.currentUser?.displayName ?? 'Nalendra',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A3A6B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.currentUser?.email ?? 'nalendra@lingoleap.com',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid cards
          Row(
            children: [
              Expanded(child: _buildHeroStatTile('🔥 Streak', '${controller.streak.value} Hari', Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildHeroStatTile('⚡ Level', '${controller.level.value}', Colors.amber[800]!)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildHeroStatTile('💎 Permata', '${controller.gems.value} Gems', Colors.cyan)),
              const SizedBox(width: 12),
              Expanded(child: _buildHeroStatTile('❤️ Nyawa', '${controller.hearts.value}/5', Colors.red)),
            ],
          ),

          const SizedBox(height: 24),

          // Achievements list
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PENCAPAIAN PAHLAWAN',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAchievementRow('🏆', 'Langkah Pertama', 'Selesaikan misi pertama petualanganmu.', true),
          const SizedBox(height: 10),
          _buildAchievementRow('👑', 'Bintang Liga', 'Tembus ranking top 3 di papan skor global.', true),
          const SizedBox(height: 10),
          _buildAchievementRow('⚡', 'Guru Bahasa', 'Kumpulkan total 200 XP dari belajar.', false),

          const SizedBox(height: 32),

          // Log out button
          _buildTactile3DButton(
            onPressed: () => controller.logout(),
            text: 'LOG OUT',
            color: const Color(0xFFE53935),
            shadowColor: const Color(0xFFC62828),
            textColor: Colors.white,
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- SUB WIDGETS ---

  // Cute Custom Frog Mascot Drawn in Flutter
  Widget _buildFrogMascot(String message) {
    return Column(
      children: [
        // Speech Bubble
        Container(
          margin: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3DAA4C), width: 1.5),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF2A7C36),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        
        // Custom Vector-style Frog character using standard Containers
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Frog Feet
              Positioned(
                bottom: 8,
                left: 30,
                child: Container(
                  width: 16,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3DAA4C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 30,
                child: Container(
                  width: 16,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3DAA4C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              
              // Frog Body
              Positioned(
                bottom: 12,
                child: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3DAA4C),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              
              // Red Scarf tail hanging down
              Positioned(
                bottom: 30,
                left: 28,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(15 / 360),
                  child: Container(
                    width: 10,
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              
              // Red Scarf wrapped around neck
              Positioned(
                bottom: 45,
                child: Container(
                  width: 52,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              
              // Frog Head
              Positioned(
                top: 25,
                child: Container(
                  width: 72,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3DAA4C),
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              
              // Left Eye
              Positioned(
                top: 20,
                left: 24,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Right Eye
              Positioned(
                top: 20,
                right: 24,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Mascot Stats Box underneath name
  Widget _buildMascotStatsBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Column 1: Beruntun
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beruntun',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${controller.streak.value}',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF1A3A6B),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Divider
          Container(width: 1.5, height: 28, color: const Color(0xFFE2E2E2)),
          
          // Column 2: Lvl
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${controller.level.value}',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF1A3A6B),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Row Item for Exercises (Quest Tab - Screen 2)
  Widget _buildExerciseRowCard(ExerciseModel ex) {
    final isActive = ex.status.value == 'active';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFF0079C1) : const Color(0xFFE2E2E2),
          width: isActive ? 2 : 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getIconForExercise(ex.icon),
                color: isActive ? const Color(0xFF0079C1) : Colors.grey,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ex.title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isActive ? const Color(0xFF1A3A6B) : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ex.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isActive ? const Color(0xFF555555) : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Action Status (Lock or Sedang button)
          if (isActive) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SEDANG',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0079C1),
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: () => controller.startQuiz(ex.title, ex.questions),
              child: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF0079C1), size: 30),
            ),
          ] else ...[
            const Icon(Icons.lock_rounded, color: Colors.grey, size: 20),
          ]
        ],
      ),
    );
  }

  // Row Item for Games (Progress Tab - Screen 3)
  Widget _buildGameRowCard(GameModel game) {
    // Difficulty pill colors
    final Color diffColor;
    if (game.difficulty == 'Mudah') {
      diffColor = const Color(0xFF4CAF50);
    } else if (game.difficulty == 'Sedang') {
      diffColor = const Color(0xFFFF9800);
    } else {
      diffColor = const Color(0xFFF44336);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
      ),
      child: Row(
        children: [
          // Square Left Box with specific color for game type
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _getBgColorForGame(game.icon),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                _getIconForExercise(game.icon),
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      game.title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1A3A6B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        game.difficulty,
                        style: GoogleFonts.plusJakartaSans(
                          color: diffColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Stars
                    _buildStarRating(game.stars.value),
                    const SizedBox(width: 12),
                    Text(
                      'Dapatkan +${game.xpReward} XP',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Green Play Button
          GestureDetector(
            onTap: () => controller.startQuiz(game.title, game.questions),
            child: Container(
              height: 38,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2A7C36),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF3DAA4C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Main',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3D tactile card generator for Screen 1
  Widget _build3DModeCard({
    required String title,
    required String desc,
    required String badgeText,
    required Color badgeBgColor,
    required Color cardBgColor,
    required Color shadowColor,
    required IconData icon,
    required String actionText,
    required VoidCallback onTap,
    Widget? extraWidget,
  }) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: shadowColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
                // Icon circle white
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ),
            if (extraWidget != null) extraWidget,
            
            const SizedBox(height: 10),
            
            // White Button
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      actionText,
                      style: GoogleFonts.outfit(
                        color: cardBgColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Locked mode card in Screen 1
  Widget _buildLockedModeCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'TERKUNCI',
                style: GoogleFonts.outfit(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
            
            const Expanded(child: SizedBox()),
            
            // Center lock details
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Selesaikan Tutorial untuk Membuka',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const Expanded(child: SizedBox()),
            
            // Gray button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Jelajahi Peta',
                  style: GoogleFonts.outfit(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Daily Mission Card in Screen 1
  Widget _buildDailyMissionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF8D6E63), // Golden-brown/brown
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Gold trophy
              const Text('🏆', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Misi Harian: Berani Bicara!',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ucapkan 5 kata baru untuk mendapatkan 20 XP tambahan.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          Row(
            children: [
              Text(
                '2 / 5 Kata',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.4,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper star builder
  Widget _buildStarRating(int filledStars) {
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          index < filledStars ? Icons.star_rounded : Icons.star_outline_rounded,
          color: index < filledStars ? Colors.amber : Colors.grey[300],
          size: 16,
        );
      }),
    );
  }

  // Dynamic icon selector based on key
  IconData _getIconForExercise(String iconKey) {
    switch (iconKey) {
      case 'puzzle':
        return Icons.extension_rounded;
      case 'mic':
        return Icons.mic_rounded;
      case 'lightning':
        return Icons.bolt_rounded;
      case 'magic_wand':
        return Icons.auto_fix_high_rounded;
      case 'document':
        return Icons.edit_note_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  // Dynamic background selector for game cards
  Color _getBgColorForGame(String iconKey) {
    switch (iconKey) {
      case 'puzzle':
        return const Color(0xFF2196F3); // Blue
      case 'mic':
        return const Color(0xFF8D6E63); // Brown
      case 'lightning':
        return const Color(0xFFFFCDD2); // Soft pink
      case 'document':
        return const Color(0xFF8BC34A); // Lime green
      default:
        return Colors.blue;
    }
  }

  Widget _buildHeroStatTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow(String emoji, String title, String desc, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFFFAF9EF) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Opacity(
                opacity: isUnlocked ? 1.0 : 0.35,
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isUnlocked ? const Color(0xFF1A3A6B) : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: isUnlocked ? const Color(0xFF3DAA4C) : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTactile3DButton({
    required VoidCallback? onPressed,
    required String text,
    required Color color,
    required Color shadowColor,
    Color textColor = Colors.white,
    double height = 50,
  }) {
    final bool isDisabled = onPressed == null;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey[300] : shadowColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: isDisabled ? 0 : 4),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[400] : color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- QUIZ OVERLAY SCREEN ---
  Widget _buildQuizOverlay(BuildContext context) {
    final title = controller.activeQuizTitle.value;
    final question = controller.activeQuestions[controller.currentQuestionIndex.value];
    final totalQuestions = controller.activeQuestions.length;
    final progress = (controller.currentQuestionIndex.value + 1) / totalQuestions;
    
    return Container(
      color: const Color(0xFFFAF9EF),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar (Quit Button & Progress Bar)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28, color: Colors.grey),
                    onPressed: () {
                      _showQuitQuizConfirmation();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3DAA4C)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      const Text('❤️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.hearts.value}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Question area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TANTANGAN ${controller.currentQuestionIndex.value + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3DAA4C),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.questionText,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A3A6B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // Options List
                    ...List.generate(question.options.length, (index) {
                      final optionText = question.options[index];
                      return _buildQuizOptionRow(optionText, index);
                    }),
                  ],
                ),
              ),
            ),
            
            // Bottom bar validation state
            _buildQuizBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizOptionRow(String text, int index) {
    final isSelected = controller.selectedOptionIndex.value == index;
    final isChecked = controller.isAnswerChecked.value;
    final question = controller.activeQuestions[controller.currentQuestionIndex.value];
    final isCorrectOption = question.correctOptionIndex == index;
    
    Color border = const Color(0xFFE2E2E2);
    Color fill = Colors.white;
    Color textCol = const Color(0xFF1A1A1A);
    
    if (isSelected) {
      border = const Color(0xFF1A3A6B);
      fill = const Color(0xFF1A3A6B);
    }
    
    if (isChecked) {
      if (isCorrectOption) {
        border = const Color(0xFF3DAA4C);
        fill = const Color(0xFF3DAA4C);
        textCol = const Color(0xFF2A7C36);
      } else if (isSelected && !isCorrectOption) {
        border = Colors.red;
        fill = Colors.red;
        textCol = Colors.red[800]!;
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: border,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => controller.selectOption(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  // Option Badge circle (A, B, C, D)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1A3A6B) : Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1A3A6B) : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textCol,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizBottomBar() {
    final isSelected = controller.selectedOptionIndex.value != null;
    final isChecked = controller.isAnswerChecked.value;
    final isCorrect = controller.isAnswerCorrect.value;
    
    Color barBg = Colors.white;
    if (isChecked) {
      barBg = isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    }
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isChecked) ...[
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: isCorrect ? const Color(0xFF3DAA4C) : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Jawaban Benar! Hebat!' : 'Jawaban Salah!',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: isCorrect ? const Color(0xFF2A7C36) : Colors.red[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Action Button (3D tactile style)
          Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              color: !isSelected 
                  ? Colors.grey[300] 
                  : (isChecked 
                      ? (isCorrect ? const Color(0xFF2A7C36) : const Color(0xFF9E2A2B))
                      : const Color(0xFF0F2342)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: !isSelected ? 0 : 4),
              decoration: BoxDecoration(
                color: !isSelected 
                    ? Colors.grey[400] 
                    : (isChecked 
                        ? (isCorrect ? const Color(0xFF3DAA4C) : const Color(0xFFE53935))
                        : const Color(0xFF1A3A6B)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: !isSelected 
                      ? null 
                      : (isChecked ? () => controller.nextQuestion() : () => controller.checkAnswer()),
                  child: Center(
                    child: Text(
                      isChecked ? 'LANJUTKAN' : 'PERIKSA JAWABAN',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuitQuizConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Keluar dari Misi?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF1A3A6B)),
        ),
        content: Text(
          'Keluar dari misi sekarang akan menghilangkan semua progresmu untuk level ini.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.isQuizActive.value = false; // Close Quiz view
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Keluar', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
