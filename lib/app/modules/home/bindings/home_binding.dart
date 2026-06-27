import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../quest/controllers/quest_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController(), permanent: true);
    }
    Get.lazyPut<QuestController>(() => QuestController());
    Get.lazyPut<ProgressController>(() => ProgressController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
