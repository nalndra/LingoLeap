import 'package:get/get.dart';

import '../controllers/game_kosakata_controller.dart';

class GameKosakataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameKosakataController>(
      () => GameKosakataController(),
    );
  }
}
