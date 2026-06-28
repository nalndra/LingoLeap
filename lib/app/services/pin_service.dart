import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PinService extends GetxService {
  static const String _pinKey = 'parent_pin';
  late SharedPreferences _prefs;
  final RxBool hasPin = false.obs;

  Future<PinService> init() async {
    _prefs = await SharedPreferences.getInstance();
    hasPin.value = _prefs.containsKey(_pinKey);
    return this;
  }

  void savePinLocalOnly(String pin) {
    _prefs.setString(_pinKey, pin);
    hasPin.value = true;
  }

  void saveCredentials(String email, String password) {
    _prefs.setString('parent_email', email);
    _prefs.setString('parent_password', password);
  }

  String? getSavedEmail() => _prefs.getString('parent_email');
  String? getSavedPassword() => _prefs.getString('parent_password');

  void clearLocalPin() {
    _prefs.remove(_pinKey);
    hasPin.value = false;
  }

  Future<void> savePin(String pin) async {
    await _prefs.setString(_pinKey, pin);
    hasPin.value = true;
    
    // Sync to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'pin': pin});
      } catch (e) {
        print("Failed to sync PIN to Firestore: $e");
      }
    }
  }

  Future<void> removePin() async {
    await _prefs.remove(_pinKey);
    hasPin.value = false;
    
    // Sync to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'pin': FieldValue.delete()});
      } catch (e) {
        print("Failed to remove PIN from Firestore: $e");
      }
    }
  }

  bool verifyPin(String enteredPin) {
    final savedPin = _prefs.getString(_pinKey);
    return savedPin == enteredPin;
  }
}
