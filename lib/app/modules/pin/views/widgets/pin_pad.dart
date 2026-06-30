import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/pin_controller.dart';

class PinPad extends GetView<PinController> {
  const PinPad({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        children: [
        // Dots / Inputs
        Obx(() {
          final input = controller.currentInput.value;
          return LayoutBuilder(
            builder: (_, constraints) {
              const gap = 12.0;
              final boxSize =
                  ((constraints.maxWidth - gap * 3) / 4).clamp(48.0, 64.0);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < input.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: gap / 2),
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF388E3C),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isFilled ? input[index] : '-',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        }),
        const SizedBox(height: 50),
        // Numpad Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.2, // Adjust to match rounded square shape
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index == 9) return const SizedBox(); // Empty bottom-left space
            
            final isBackspace = index == 11;
            final number = isBackspace ? '' : (index == 10 ? '0' : '${index + 1}');

            return GestureDetector(
              onTap: () {
                if (isBackspace) {
                  controller.removeDigit();
                } else {
                  controller.addDigit(number);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF388E3C),
                      offset: Offset(0, 5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: isBackspace
                      ? const Icon(Icons.backspace, color: Color(0xFF4CAF50), size: 28)
                      : Text(
                          number,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                ),
              ),
            );
          },
        ),
        ],
      ),
    );
  }
}
