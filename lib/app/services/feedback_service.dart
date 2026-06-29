import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralises haptic + audio feedback for all game interactions.
/// Respects pref_sound / pref_vibration from SettingController.
class FeedbackService extends GetxService {
  static const _kSound     = 'pref_sound';
  static const _kVibration = 'pref_vibration';

  bool soundEnabled     = true;
  bool vibrationEnabled = true;

  Future<FeedbackService> init() async {
    await _loadPrefs();
    return this;
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    soundEnabled     = p.getBool(_kSound)     ?? true;
    vibrationEnabled = p.getBool(_kVibration) ?? true;
  }

  /// Call this after the user toggles a pref in SettingController.
  void sync({required bool sound, required bool vibration}) {
    soundEnabled     = sound;
    vibrationEnabled = vibration;
  }

  /// Ketuk huruf / pilihan → klik ringan + getaran seleksi.
  void tap() {
    if (soundEnabled)     SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) HapticFeedback.selectionClick();
  }

  /// Jawaban salah → getaran kuat.
  void wrong() {
    if (vibrationEnabled) HapticFeedback.heavyImpact();
  }
}
