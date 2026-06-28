import 'package:get/get.dart';

import '../controllers/game_rima_controller.dart';

class GameRimaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameRimaController>(
      () => GameRimaController(),
    );
  }
}
