import 'package:get/get.dart';
import '../controllers/parent_login_controller.dart';

class ParentLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentLoginController>(
      () => ParentLoginController(),
    );
  }
}
