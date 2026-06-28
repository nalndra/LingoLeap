import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  HomeController get _home => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2977C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Level ${_home.level.value}',
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
                    errorBuilder: (ctx, e, s) => const Icon(
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
                    '${_home.xp.value}/1000 XP',
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
                  value: (_home.xp.value / 1000).clamp(0.0, 1.0),
                  minHeight: 14,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A3A6B)),
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
      _QuestStep(
          label: 'Suku Kata', icon: Icons.text_fields_rounded, done: true),
      _QuestStep(label: 'KosaKata', icon: Icons.menu_book_rounded, done: false),
      _QuestStep(
          label: 'Fonem Kata', icon: Icons.volume_up_rounded, done: false),
      _QuestStep(
          label: 'Rima kata', icon: Icons.headphones_rounded, done: false),
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
}

class _QuestStep {
  final String label;
  final IconData icon;
  final bool done;
  const _QuestStep(
      {required this.label, required this.icon, required this.done});
}
