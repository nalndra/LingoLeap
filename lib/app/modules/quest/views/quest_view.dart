import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/quest_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';

// ─── Node status ──────────────────────────────────────────────────────────────

enum _NS { done, current, locked }

class _NodeState {
  final _NS status;
  final IconData icon;
  final Color color;
  final Color darkColor;
  const _NodeState({
    required this.status,
    required this.icon,
    required this.color,
    required this.darkColor,
  });
}

// ─── Quest View ───────────────────────────────────────────────────────────────

class QuestView extends GetView<QuestController> {
  const QuestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _QuestHeader(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2977C7)),
              );
            }
            return _SnakeMap(
              key: ValueKey(controller.currentLevel.value),
              currentLevel: controller.currentLevel.value,
              onTapLevel: controller.playLevel,
              defAt: controller.defAt,
            );
          }),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _QuestHeader extends StatelessWidget {
  const _QuestHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E0D4), width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.find<HomeController>().changeTab(0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8DE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Petualangan',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF222222),
            ),
          ),
          const Spacer(),
          Obx(() {
            final lvl = Get.find<QuestController>().currentLevel.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2977C7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Level $lvl',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
  final int currentLevel;
  final void Function(int) onTapLevel;
  final QuestLevelDef Function(int) defAt;

  const _SnakeMap({
    super.key,
    required this.currentLevel,
    required this.onTapLevel,
    required this.defAt,
  });

  @override
  State<_SnakeMap> createState() => _SnakeMapState();
}

class _SnakeMapState extends State<_SnakeMap> {
  final _sc = ScrollController();

  // ── Layout constants (compact) ────────────────────────────────────────────
  static const _kHPad     = 24.0;
  static const _kNodeSz   = 56.0;   // unlocked node diameter
  static const _kRowPad   = 8.0;    // top & bottom padding per row
  static const _kVertH    = 30.0;   // vertical connector height
  // Section = row + connector: 56 + 8*2 + 30 = 102
  static const _kSectionH = _kNodeSz + _kRowPad * 2 + _kVertH;
  // Bar offset = hpad + node_radius - half_bar_width = 24 + 28 - 7 = 45
  static const _kEdge     = _kHPad + _kNodeSz / 2 - 7;

  int get _totalRows => ((widget.currentLevel + 2) ~/ 2) + 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _scrollToCurrent() {
    if (!_sc.hasClients) return;
    final row    = (widget.currentLevel + 1) ~/ 2;
    final offset = (row * _kSectionH - 60.0)
        .clamp(0.0, _sc.position.maxScrollExtent);
    _sc.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  // ── Path → node state ─────────────────────────────────────────────────────

  _NodeState _stateAt(int pathIdx) {
    if (pathIdx == 0) {
      return const _NodeState(
        status: _NS.done,
        icon: Icons.flag_rounded,
        color: Color(0xFF2977C7),
        darkColor: Color(0xFF1A5EA0),
      );
    }
    final lvl = pathIdx - 1;
    final def = widget.defAt(lvl);
    final st  = lvl < widget.currentLevel
        ? _NS.done
        : lvl == widget.currentLevel
            ? _NS.current
            : _NS.locked;
    return _NodeState(
      status: st,
      icon:   st == _NS.done ? Icons.check_rounded : def.icon,
      color:  def.color,
      darkColor: def.darkColor,
    );
  }

  void _onTap(int pathIdx) {
    if (pathIdx == 0) return;
    widget.onTapLevel(pathIdx - 1);
  }

  // ── Snake row ─────────────────────────────────────────────────────────────

  Widget _buildRow(int r) {
    final isLTR     = r.isEven;
    final leftPath  = isLTR ? 2 * r     : 2 * r + 1;
    final rightPath = isLTR ? 2 * r + 1 : 2 * r;

    final leftSt  = _stateAt(leftPath);
    final rightSt = _stateAt(rightPath);

    final entrySt  = isLTR ? leftSt : rightSt;
    final exitSt   = isLTR ? rightSt : leftSt;
    final dashDone = entrySt.status == _NS.done && exitSt.status == _NS.done;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: _kRowPad, horizontal: _kHPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NodeWidget(state: leftSt,  size: _kNodeSz, onTap: () => _onTap(leftPath)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (_) => _DashPill(done: dashDone)),
              ),
            ),
          ),
          _NodeWidget(state: rightSt, size: _kNodeSz, onTap: () => _onTap(rightPath)),
        ],
      ),
    );
  }

  // ── Vertical connector ────────────────────────────────────────────────────

  Widget _buildVertConn(int afterRow) {
    final onRight  = afterRow.isEven;
    final lastPath = 2 * afterRow + 1;
    final connDone = _stateAt(lastPath).status == _NS.done;
    final color    = connDone
        ? const Color(0xFF2977C7)
        : const Color(0xFFDDDDDD);

    final bar = Container(
      width: 12,
      height: _kVertH,
      decoration: BoxDecoration(
        color: color,
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
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _sc,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 100),
            child: Column(
              children: [
                for (int r = 0; r < _totalRows; r++) ...[
                  _buildRow(r),
                  if (r < _totalRows - 1) _buildVertConn(r),
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
  }
}

// ─── Node Widget ──────────────────────────────────────────────────────────────

class _NodeWidget extends StatelessWidget {
  final _NodeState state;
  final double size;
  final VoidCallback onTap;

  const _NodeWidget({
    required this.state,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked  = state.status == _NS.locked;
    final isCurrent = state.status == _NS.current;

    final sz        = isLocked ? size - 8 : size;
    final mainColor = isLocked ? const Color(0xFFBBBBBB) : state.color;
    final darkColor = isLocked ? const Color(0xFF8A8A8A) : state.darkColor;
    final iconColor = isLocked ? const Color(0xFF777777) : Colors.white;
    final iconSz    = sz * 0.46;

    final nodeBody = Container(
      width: sz,
      height: sz,
      decoration: BoxDecoration(color: darkColor, shape: BoxShape.circle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: mainColor,
          shape: BoxShape.circle,
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: state.color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(state.icon, color: iconColor, size: iconSz),
        ),
      ),
    );

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(child: nodeBody),
      ),
    );
  }
}

// ─── Dash Pill ────────────────────────────────────────────────────────────────

class _DashPill extends StatelessWidget {
  final bool done;
  const _DashPill({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 10,
      decoration: BoxDecoration(
        color: done ? const Color(0xFF2977C7) : const Color(0xFFDDDDDD),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

// ─── Tanya Lippo FAB ─────────────────────────────────────────────────────────

class _LippoFab extends StatelessWidget {
  const _LippoFab();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CHAT_LIPPO),
      child: Container(
        width: 76,
        decoration: BoxDecoration(
          color: const Color(0xFF1A5EA0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2977C7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/lippo_icon.png', width: 44),
              const SizedBox(height: 3),
              Text(
                'Tanya\nLippo',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
