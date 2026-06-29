import 'package:get/get.dart';

import '../controllers/petualangan_controller.dart';

class PetualanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetualanganController>(
      () => PetualanganController(),
    );
  }
}
