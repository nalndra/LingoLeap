import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modules/home/controllers/home_controller.dart';
import '../routes/app_pages.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  HomeController get _home => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar square — tampilkan foto profil jika tersedia
        Obx(() {
          final url = _home.photoUrl.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: url.isNotEmpty
                ? Image.network(url,
                    width: 56, height: 56, fit: BoxFit.cover,
                    errorBuilder: (ctx, e, s) => _defaultAvatar())
                : _defaultAvatar(),
          );
        }),
        const SizedBox(width: 12),

        // Name + stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                _home.childName.value.isEmpty ? 'Pahlawan' : _home.childName.value,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2977C7),
                ),
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFE53935), size: 16),
                  const SizedBox(width: 3),
                  Obx(() => Text(
                        '${_home.hearts.value}/5',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      )),
                  const SizedBox(width: 12),
                  const Text('✨', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 3),
                  Obx(() => Text(
                        '${_home.xp.value} XP',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),

        // Rank badge
        Obx(() => Image.asset(
              _home.rankBadgeAsset,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) => const Icon(
                Icons.military_tech_rounded,
                size: 40,
                color: Color(0xFFCD7F32),
              ),
            )),
        const SizedBox(width: 10),

        // Settings button → navigasi ke Setting page
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SETTING),
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

  Widget _defaultAvatar() => Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
      );
}
