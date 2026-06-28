import 'package:get/get.dart';

import '../controllers/game_fonem_controller.dart';

class GameFonemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameFonemController>(
      () => GameFonemController(),
    );
  }
}
