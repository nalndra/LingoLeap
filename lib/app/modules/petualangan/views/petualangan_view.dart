import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/petualangan_controller.dart';
import '../../../routes/app_pages.dart';

// ─── Node state ───────────────────────────────────────────────────────────────

enum _NS { done, playable, locked }

class _Node {
  final _NS status;
  final IconData icon;
  final Color color;
  final Color darkColor;
  final bool isCurrent; // first non-completed playable → glow
  const _Node({
    required this.status,
    required this.icon,
    required this.color,
    required this.darkColor,
    this.isCurrent = false,
  });
}

// ─── Petualangan View ─────────────────────────────────────────────────────────

class PetualanganView extends GetView<PetualanganController> {
  const PetualanganView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF2977C7)),
                  );
                }
                return _SnakeMap(controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button — gaya mini-game: lingkaran biru
          GestureDetector(
            onTap: Get.back,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF2977C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Petualangan',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                    height: 1.1,
                  ),
                ),
                Obx(() {
                  final n = controller.completedLevels.length;
                  return Text(
                    '$n level selesai',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF888888),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Player badge
          Obx(() {
            final name = controller.playerName.value;
            final xp   = controller.completedLevels.length;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF2977C7), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2977C7).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2977C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name.isEmpty ? 'Petualang' : name,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '$xp XP',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2977C7),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Snake Map ────────────────────────────────────────────────────────────────

class _SnakeMap extends StatefulWidget {
  final PetualanganController controller;
  const _SnakeMap({required this.controller});

  @override
  State<_SnakeMap> createState() => _SnakeMapState();
}

class _SnakeMapState extends State<_SnakeMap> {
  final _sc = ScrollController();

  PetualanganController get c => widget.controller;

  // ── Layout constants ──────────────────────────────────────────────────────
  static const _kHPad    = 44.0;   // safe zone kiri & kanan — node lebih ke tengah
  static const _kNodeSz  = 62.0;   // unlocked node diameter
  static const _kRowPad  = 10.0;   // top + bottom per row
  static const _kVertH   = 28.0;   // vertical connector height
  // bar offset = hpad + radius - half_bar_width = 44+31-6 = 69
  static const _kEdge    = _kHPad + _kNodeSz / 2 - 6;
  // section height = node + 2*rowPad + vertH = 62+20+28 = 110
  static const _kSectionH = _kNodeSz + _kRowPad * 2 + _kVertH;

  // Total rows to render (capped so dev mode doesn't render 5000 rows)
  int _totalRows(int unlocked) =>
      min(16, ((unlocked + 2) ~/ 2) + 4).clamp(5, 16);

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  // ── Path index → node data ────────────────────────────────────────────────
  // path[0] = START FLAG, path[k] (k≥1) = game level k-1

  _Node _nodeAt(int pathIdx, int unlocked, List<int> completed) {
    if (pathIdx == 0) {
      // Node Tutorial — done jika tutorialCompleted, playable jika belum
      final tutDone = c.tutorialCompleted.value;
      return _Node(
        status: tutDone ? _NS.done : _NS.playable,
        icon: Icons.explore_rounded,
        color: const Color(0xFF4CAF50),
        darkColor: const Color(0xFF338A3E),
        isCurrent: !tutDone,
      );
    }
    final lvl = pathIdx - 1;
    final def = c.defAt(lvl);

    if (lvl >= unlocked) {
      return _Node(
        status: _NS.locked,
        icon: Icons.lock_rounded,
        color: const Color(0xFFBBBBBB),
        darkColor: const Color(0xFF8A8A8A),
      );
    }

    final isDone = completed.contains(lvl);
    // "current" = first unlocked-but-not-completed level
    final firstPlayable = Iterable<int>.generate(unlocked)
        .firstWhere((i) => !completed.contains(i), orElse: () => -1);

    return _Node(
      status: isDone ? _NS.done : _NS.playable,
      icon: def.icon,
      color: def.color,
      darkColor: def.darkColor,
      isCurrent: !isDone && lvl == firstPlayable,
    );
  }

  void _onTap(int pathIdx) {
    if (pathIdx == 0) {
      c.playTutorial();
      return;
    }
    c.playLevel(pathIdx - 1);
  }

  // ── Row (even = L→R, odd = R→L) ──────────────────────────────────────────
  Widget _buildRow(
      int r, int unlocked, List<int> completed) {
    final isLTR    = r.isEven;
    final leftPath = isLTR ? 2 * r     : 2 * r + 1;
    final rightPath= isLTR ? 2 * r + 1 : 2 * r;

    final leftN  = _nodeAt(leftPath,  unlocked, completed);
    final rightN = _nodeAt(rightPath, unlocked, completed);

    // Dashes colored when entry node is done (path sudah dilalui menuju exit)
    final entryN = isLTR ? leftN : rightN;
    final dashDone = entryN.status == _NS.done;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: _kRowPad, horizontal: _kHPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NodeCircle(node: leftN,  onTap: () => _onTap(leftPath)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (_) => _Dash(done: dashDone)),
            ),
          ),
          _NodeCircle(node: rightN, onTap: () => _onTap(rightPath)),
        ],
      ),
    );
  }

  // ── Vertical connector after row r ────────────────────────────────────────
  Widget _buildVertConn(int afterRow, int unlocked, List<int> completed) {
    final onRight = afterRow.isEven;

    // Path goes: last node of current row → first node of next row
    final fromPath = 2 * afterRow + 1;
    final fromN    = _nodeAt(fromPath, unlocked, completed);
    final connDone = fromN.status == _NS.done;

    final bar = Container(
      width: 12,
      height: _kVertH,
      decoration: BoxDecoration(
        color: connDone
            ? const Color(0xFF2977C7)
            : const Color(0xFFD0CAC0),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return onRight
        ? Padding(
            padding: const EdgeInsets.only(right: _kEdge),
            child: Align(alignment: Alignment.centerRight, child: bar))
        : Padding(
            padding: const EdgeInsets.only(left: _kEdge),
            child: Align(alignment: Alignment.centerLeft, child: bar));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unlocked  = c.unlockedCount.value;
      final completed = c.completedLevels.toList();
      final rows      = _totalRows(unlocked);

      // Scroll to current level position on first build / unlock change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sc.hasClients) return;
        final firstPlayable = Iterable<int>.generate(unlocked)
            .firstWhere((i) => !completed.contains(i), orElse: () => 0);
        final row = (firstPlayable + 1) ~/ 2;
        final offset = (row * _kSectionH - 80.0)
            .clamp(0.0, _sc.position.maxScrollExtent);
        _sc.animateTo(offset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });

      return Stack(
        children: [
          SingleChildScrollView(
            controller: _sc,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 120),
              child: Column(
                children: [
                  for (int r = 0; r < rows; r++) ...[
                    _buildRow(r, unlocked, completed),
                    if (r < rows - 1)
                      _buildVertConn(r, unlocked, completed),
                  ],
                ],
              ),
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 20,
            child: _LippoFab(),
          ),
        ],
      );
    });
  }
}

// ─── Node Circle ──────────────────────────────────────────────────────────────

class _NodeCircle extends StatelessWidget {
  final _Node node;
  final VoidCallback onTap;
  const _NodeCircle({required this.node, required this.onTap});

  static const _kSz       = 62.0;
  static const _kSzLocked = 54.0;

  @override
  Widget build(BuildContext context) {
    final isLocked = node.status == _NS.locked;
    final sz       = isLocked ? _kSzLocked : _kSz;
    final iconSz   = sz * 0.44;

    // 3-D button: dark outer circle + colored face shifted up by 4px
    final circle = Container(
      width: sz,
      height: sz,
      decoration: BoxDecoration(
        color: node.darkColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: node.color,
          shape: BoxShape.circle,
          boxShadow: node.isCurrent
              ? [
                  BoxShadow(
                    color: node.color.withValues(alpha: 0.55),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(node.icon, color: Colors.white, size: iconSz),
        ),
      ),
    );

    // Fixed bounding box: always _kSz wide so Row stays aligned
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: SizedBox(
        width: _kSz,
        height: _kSz,
        child: Center(child: circle),
      ),
    );
  }
}

// ─── Dash Connector ───────────────────────────────────────────────────────────

class _Dash extends StatelessWidget {
  final bool done;
  const _Dash({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 14,
      decoration: BoxDecoration(
        color: done
            ? const Color(0xFF2977C7)
            : const Color(0xFFD0CAC0),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}

// ─── Tanya Lippo FAB ─────────────────────────────────────────────────────────

class _LippoFab extends StatelessWidget {
  const _LippoFab();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2977C7);
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CHAT_LIPPO),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: blue, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: blue.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.5),
          child: Column(
            children: [
              // Area putih — icon lippo
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/icons/lippo_icon.png',
                    width: 68,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Label biru di bawah
              Container(
                width: double.infinity,
                color: blue,
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  'Tanya Lippo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
