import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/pin_service.dart';
import '../controllers/parent_settings_controller.dart';

class ParentSettingsView extends GetView<ParentSettingsController> {
  const ParentSettingsView({super.key});

  // Design colors — user-specified
  static const _bgColor = Color(0xFFFCFAED);
  static const _blue = Color(0xFF2977C7);
  static const _green = Color(0xFF4CAF50);
  static const _red = Color(0xFFEB4B4B);

  // Rotating child avatar colors
  static const _childColors = [
    Color(0xFF2977C7), // Blue
    Color(0xFFEB4B4B), // Red
    Color(0xFF4CAF50), // Green
    Color(0xFFF07B26), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header ───
                  Row(
                    children: [
                      // Back button — green circle like mockup
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: _green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                          onPressed: () {
                            if (Get.previousRoute.isEmpty) {
                              Get.offNamed('/parent-dashboard');
                            } else {
                              Get.back();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Pengaturan',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance the back button
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Profile Card (Green Gradient) ───
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          offset: const Offset(0, 6),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar — white bg with green icon
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: Color(0xFF4CAF50), size: 34),
                          ),
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
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                controller.parentEmail.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Edit Profil',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.edit, size: 14, color: Colors.white.withOpacity(0.9)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Profil Anak ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profil Anak',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _blue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/add-child');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/icons/plus.png',
                                width: 16,
                                height: 16,
                                color: Colors.white,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Tambah',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Children list
                  if (controller.children.isEmpty)
                    _buildChildCard(
                      name: 'Belum ada anak',
                      detail: 'Tekan Tambah untuk menghubungkan',
                      avatarColor: _green,
                    )
                  else
                    ...controller.children.map((child) {
                      final index = controller.children.indexOf(child);
                      final colors = _childColors;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildChildCard(
                          name: child['name'] ?? 'Anak',
                          detail: 'Level ${child['level'] ?? 1} • ${child['xp'] ?? 0} XP',
                          avatarColor: colors[index % colors.length],
                        ),
                      );
                    }),
                  const SizedBox(height: 28),

                  // ─── Keamanan ───
                  Text(
                    'Keamanan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    iconAsset: null,
                    icon: Icons.lock_outline,
                    iconBgColor: _blue,
                    title: 'PIN Orang Tua',
                    subtitle: 'Batasi Akses anak ke pengaturan',
                    onTap: () {
                      final pinService = Get.find<PinService>();
                      if (pinService.hasPin.value) {
                        Get.snackbar(
                          'Info',
                          'PIN sudah diatur. Anda bisa menggunakan PIN untuk masuk.',
                          backgroundColor: Colors.white,
                          colorText: _blue,
                        );
                        // Future improvement: Navigate to Change PIN / Remove PIN
                      } else {
                        Get.toNamed('/pin-setup');
                      }
                    },
                  ),
                  const SizedBox(height: 28),

                  // ─── Preferensi ───
                  Text(
                    'Preferensi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    iconAsset: 'assets/icons/premium.png',
                    icon: null,
                    iconBgColor: _blue,
                    title: 'Langganan Premium',
                    subtitle: 'Belum Aktif',
                    subtitleColor: Colors.grey,
                    onTap: () => Get.toNamed('/premium'),
                  ),
                  const SizedBox(height: 36),

                  // ─── Log Out Button ───
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: controller.logout,
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Child Card ───
  Widget _buildChildCard({
    required String name,
    required String detail,
    required Color avatarColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle — using project icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/profile_avatar.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.85),
                colorBlendMode: BlendMode.srcATop,
                errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                Text(
                  detail,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
        ],
      ),
    );
  }

  // ─── Settings Tile ───
  Widget _buildSettingsTile({
    required String? iconAsset,
    required IconData? icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle — solid background like mockup
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset,
                        width: 22,
                        height: 22,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.star, size: 22, color: Colors.white),
                      )
                    : Icon(icon, size: 22, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: subtitleColor ?? Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
