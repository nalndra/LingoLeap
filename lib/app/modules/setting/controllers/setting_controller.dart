import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../../services/child_progress_service.dart';
import '../../../services/feedback_service.dart';
import '../../../services/pin_service.dart';

class SettingController extends GetxController {
  final userName  = ''.obs;
  final userEmail = ''.obs;
  final photoUrl  = ''.obs;

  // Preferensi — persisted ke SharedPreferences
  final audioEnabled     = true.obs;
  final soundEnabled     = true.obs;
  final vibrationEnabled = true.obs;

  static const _kAudio     = 'pref_audio';
  static const _kSound     = 'pref_sound';
  static const _kVibration = 'pref_vibration';

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadPrefs();
    // Tetap sinkron saat ChildProgressService memperbarui name/photo
    try {
      final svc = Get.find<ChildProgressService>();
      ever(svc.childName, (v) => userName.value  = v);
      ever(svc.photoUrl,  (v) => photoUrl.value  = v);
    } catch (_) {}
  }

  void _loadUser() {
    final user = FirebaseAuth.instance.currentUser;
    userName.value  = user?.displayName ?? 'Pahlawan';
    userEmail.value = user?.email ?? '';
    // Prioritaskan data dari ChildProgressService (lebih fresh)
    try {
      final svc = Get.find<ChildProgressService>();
      if (svc.childName.value.isNotEmpty) userName.value = svc.childName.value;
      if (svc.photoUrl.value.isNotEmpty)  photoUrl.value = svc.photoUrl.value;
    } catch (_) {
      photoUrl.value = user?.photoURL ?? '';
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    audioEnabled.value     = prefs.getBool(_kAudio)     ?? true;
    soundEnabled.value     = prefs.getBool(_kSound)     ?? true;
    vibrationEnabled.value = prefs.getBool(_kVibration) ?? true;
  }

  Future<void> setAudio(bool val) async {
    audioEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAudio, val);
  }

  Future<void> setSound(bool val) async {
    soundEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSound, val);
    _syncFeedback();
  }

  Future<void> setVibration(bool val) async {
    vibrationEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVibration, val);
    _syncFeedback();
  }

  void _syncFeedback() {
    try {
      Get.find<FeedbackService>().sync(
        sound:     soundEnabled.value,
        vibration: vibrationEnabled.value,
      );
    } catch (_) {}
  }

  void goEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE)?.then((_) => _loadUser());
  }

  void goParentMode() {
    Get.toNamed(Routes.PARENT_LOGIN);
  }

  void logout() async {
    try {
      Get.find<PinService>().clearLocalPin();
      Get.find<ChildProgressService>().clearStats();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
