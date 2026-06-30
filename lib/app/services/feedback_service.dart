import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService extends GetxService {
  static const _kSound     = 'pref_sound';
  static const _kVibration = 'pref_vibration';

  bool soundEnabled     = true;
  bool vibrationEnabled = true;

  final _clickPlayer     = AudioPlayer();
  final _deletePlayer    = AudioPlayer();
  final _correctPlayer   = AudioPlayer();
  final _incorrectPlayer = AudioPlayer();

  Future<FeedbackService> init() async {
    await _loadPrefs();
    for (final p in [_clickPlayer, _deletePlayer, _correctPlayer, _incorrectPlayer]) {
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(1.0);
    }
    return this;
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    soundEnabled     = p.getBool(_kSound)     ?? true;
    vibrationEnabled = p.getBool(_kVibration) ?? true;
  }

  void sync({required bool sound, required bool vibration}) {
    soundEnabled     = sound;
    vibrationEnabled = vibration;
  }

  /// Ketuk huruf / pilihan → klik ringan.
  void tap() {
    if (soundEnabled) _clickPlayer.play(AssetSource('sfx/click_sfx.mp3'));
    if (vibrationEnabled) HapticFeedback.lightImpact();
  }

  /// Hapus huruf yang sudah disusun (tapSlot di SukuKata / KosaKata).
  void delete() {
    if (soundEnabled) _deletePlayer.play(AssetSource('sfx/delete_sfx.mp3'));
    if (vibrationEnabled) HapticFeedback.selectionClick();
  }

  /// Jawaban benar.
  void correct() {
    if (soundEnabled) _correctPlayer.play(AssetSource('sfx/correct_sfx.mp3'));
  }

  /// Jawaban salah → suara + getaran dua pulse.
  void wrong() {
    if (soundEnabled) _incorrectPlayer.play(AssetSource('sfx/incorrect_sfx.mp3'));
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 120), HapticFeedback.heavyImpact);
    }
  }

  @override
  void onClose() {
    _clickPlayer.dispose();
    _deletePlayer.dispose();
    _correctPlayer.dispose();
    _incorrectPlayer.dispose();
    super.onClose();
  }
}
