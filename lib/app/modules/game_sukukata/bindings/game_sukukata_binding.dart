import 'package:get/get.dart';

import '../controllers/game_sukukata_controller.dart';

class GameSukukataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameSukukataController>(
      () => GameSukukataController(),
    );
  }
}
