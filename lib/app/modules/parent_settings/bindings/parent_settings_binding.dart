import 'package:get/get.dart';
import '../controllers/parent_settings_controller.dart';

class ParentSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentSettingsController>(() => ParentSettingsController());
  }
}
