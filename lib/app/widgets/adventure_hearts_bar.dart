import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/child_progress_service.dart';

/// Hearts row yang muncul di atas instruksi game saat adventure mode aktif.
class AdventureHeartsBar extends StatelessWidget {
  const AdventureHeartsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final h = Get.find<ChildProgressService>().hearts.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(5, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              i < h ? Icons.favorite : Icons.favorite_border_rounded,
              color: i < h
                  ? const Color(0xFFE53935)
                  : const Color(0xFFCCCCCC),
              size: 26,
            ),
          )),
          const SizedBox(width: 8),
          Text(
            '$h/5',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: h > 0
                  ? const Color(0xFFE53935)
                  : const Color(0xFF999999),
            ),
          ),
        ],
      );
    });
  }
}
