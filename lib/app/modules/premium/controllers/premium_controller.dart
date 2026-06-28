import 'package:get/get.dart';

class PremiumController extends GetxController {
  final selectedPlan = ''.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  void subscribe() {
    if (selectedPlan.value.isEmpty) {
      Get.snackbar(
        'Pilih Paket',
        'Silakan pilih paket langganan terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // TODO: Integrate with payment gateway
    Get.snackbar(
      'Segera Hadir',
      'Pembayaran untuk ${selectedPlan.value} akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
