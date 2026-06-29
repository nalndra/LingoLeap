import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

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

  // ─── Level Card ───────────────────────────────────────────────────────────────

  Widget _buildLevelCard() {
    return Obx(() {
      final cap    = controller.rankCap;
      final xpVal  = controller.xp.value;
      final lvl    = controller.level.value;
      final barVal = controller.levelBarValue;

      // Gold: tampilkan xp asli walau melebihi cap
      final xpDisplay =
          (xpVal > cap && lvl >= 20) ? xpVal : xpVal.clamp(0, cap);

      return Container(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2977C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Level $lvl',
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
                  '$xpDisplay/$cap XP',
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
                value: barVal,
                minHeight: 14,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF1A3A6B)),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Statistic Card ───────────────────────────────────────────────────────────

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
          Obx(() => _buildStatRow(
                'Fokus',
                controller.fokus,
                const Color(0xFF2977C7),
              )),
          const SizedBox(height: 16),
          Obx(() => _buildStatRow(
                'Kecepatan Membaca',
                controller.kecepatanMembaca,
                const Color(0xFFE26C22),
              )),
          const SizedBox(height: 16),
          Obx(() => _buildStatRow(
                'Pengenalan Huruf',
                controller.pengenalanHuruf,
                const Color(0xFF4CAF50),
              )),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
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
              '$value%',
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
            value: (value / 100).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ─── Quest Journey Card ───────────────────────────────────────────────────────

  static const _kCycle = [
    _QuestDef('Suku Kata',  Icons.extension_rounded),
    _QuestDef('Kosa Kata',  Icons.menu_book_rounded),
    _QuestDef('Rima',       Icons.headphones_rounded),
    _QuestDef('Fonem',      Icons.volume_up_rounded),
  ];

  Widget _buildQuestJourneyCard() {
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
          const SizedBox(height: 6),
          Obx(() {
            final todayIdx  = controller.todayQuestCycleIdx;
            final isDone    = controller.isTodayQuestDone;
            return Text(
              todayIdx < 0
                  ? 'Mulai petualangan untuk membuka quest'
                  : isDone
                      ? 'Quest hari ini selesai! ✓'
                      : 'Quest hari ini: ${_kCycle[todayIdx].label}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: todayIdx < 0
                    ? Colors.grey[400]
                    : isDone
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF2977C7),
              ),
            );
          }),
          const SizedBox(height: 24),
          Obx(() {
            final todayIdx = controller.todayQuestCycleIdx;
            final isDone   = controller.isTodayQuestDone;

            return Row(
              children: List.generate(_kCycle.length, (i) {
                final isToday  = i == todayIdx;
                final isLast   = i == _kCycle.length - 1;
                final def      = _kCycle[i];

                final Color nodeColor;
                final Color textColor;
                final IconData nodeIcon;

                if (isToday) {
                  nodeColor = const Color(0xFF4CAF50);
                  textColor = const Color(0xFF4CAF50);
                  nodeIcon  = isDone ? Icons.check_rounded : def.icon;
                } else {
                  nodeColor = const Color(0xFFE0E0E0);
                  textColor = Colors.grey.shade400;
                  nodeIcon  = def.icon;
                }

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
                                color: nodeColor,
                                shape: BoxShape.circle,
                                boxShadow: isToday
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF4CAF50)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                nodeIcon,
                                color: isToday
                                    ? Colors.white
                                    : Colors.grey.shade500,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              def.label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 18,
                          height: 2,
                          color: const Color(0xFFE0E0E0),
                          margin: const EdgeInsets.only(bottom: 26),
                        ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _QuestDef {
  final String label;
  final IconData icon;
  const _QuestDef(this.label, this.icon);
}
