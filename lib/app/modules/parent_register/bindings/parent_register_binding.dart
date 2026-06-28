import 'package:get/get.dart';
import '../controllers/parent_register_controller.dart';

class ParentRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentRegisterController>(
      () => ParentRegisterController(),
    );
  }
}
