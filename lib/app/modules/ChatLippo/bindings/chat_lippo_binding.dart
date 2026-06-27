import 'package:get/get.dart';

import '../controllers/chat_lippo_controller.dart';

class ChatLippoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatLippoController>(
      () => ChatLippoController(),
    );
  }
}
