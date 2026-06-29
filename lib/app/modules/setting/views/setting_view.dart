import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  // ─── Warna ────────────────────────────────────────────────────────────────────
  static const _bg       = Color(0xFFF5F0E8);
  static const _green    = Color(0xFF4CAF50);
  static const _greenDk  = Color(0xFF388E3C);
  static const _blue     = Color(0xFF2977C7);
  static const _red      = Color(0xFFE53935);
  static const _redDk    = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 16),
                    _buildSettingRow(
                      icon: Icons.tune_rounded,
                      title: 'Preferensi',
                      subtitle: 'Audio, efek suara, dan getaran',
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: _blue, size: 26),
                      onTap: _showPreferensiSheet,
                    ),
                    const SizedBox(height: 12),
                    _buildSettingRow(
                      icon: Icons.shield_rounded,
                      title: 'Mode Orang Tua',
                      subtitle: 'Hanya untuk dewasa',
                      trailing: const Icon(Icons.lock_rounded,
                          color: _blue, size: 22),
                      onTap: controller.goParentMode,
                    ),
                    const SizedBox(height: 40),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Pengaturan',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Profile Card ─────────────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    return _buildCard3d(
      faceColor: _green,
      shadowColor: _greenDk,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar box
            Obx(() {
              final url = controller.photoUrl.value;
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: url.isNotEmpty
                    ? Image.network(url,
                        width: 64, height: 64, fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => _avatarFallback())
                    : _avatarFallback(),
              );
            }),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        controller.userEmail.value,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: controller.goEditProfile,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Edit Profil',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.edit_rounded,
                                color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Setting Row ──────────────────────────────────────────────────────────────

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCard3d(
        faceColor: Colors.white,
        shadowColor: const Color(0xFFCCCCCC),
        radius: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon bubble
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _blue,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // ─── Logout Button ────────────────────────────────────────────────────────────

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: controller.logout,
      child: _buildCard3d(
        faceColor: _red,
        shadowColor: _redDk,
        radius: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.logout_rounded,
                  color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Preferensi Bottom Sheet ──────────────────────────────────────────────────

  void _showPreferensiSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
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
              'Preferensi',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _blue,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => _buildPrefRow(
                  icon: Icons.music_note_rounded,
                  label: 'Audio',
                  sublabel: 'Musik latar belakang',
                  value: controller.audioEnabled.value,
                  onChanged: controller.setAudio,
                )),
            const Divider(height: 24),
            Obx(() => _buildPrefRow(
                  icon: Icons.volume_up_rounded,
                  label: 'Efek Suara',
                  sublabel: 'Suara tombol dan feedback',
                  value: controller.soundEnabled.value,
                  onChanged: controller.setSound,
                )),
            const Divider(height: 24),
            Obx(() => _buildPrefRow(
                  icon: Icons.vibration_rounded,
                  label: 'Getaran',
                  sublabel: 'Haptic feedback',
                  value: controller.vibrationEnabled.value,
                  onChanged: controller.setVibration,
                )),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildPrefRow({
    required IconData icon,
    required String label,
    required String sublabel,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _blue, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A))),
              Text(sublabel,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500])),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: _green,
          activeTrackColor: _green.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  // ─── Avatar fallback ──────────────────────────────────────────────────────────

  Widget _avatarFallback() {
    return Container(
      width: 64,
      height: 64,
      color: Colors.white,
      child: const Icon(Icons.person_rounded, color: _green, size: 38),
    );
  }

  // ─── Reusable 3-D card ────────────────────────────────────────────────────────

  Widget _buildCard3d({
    required Color faceColor,
    required Color shadowColor,
    required double radius,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: shadowColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: faceColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
