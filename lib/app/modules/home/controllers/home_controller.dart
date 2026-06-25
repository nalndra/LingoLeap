import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  
  final selectedIndex = 0.obs;

  final List<Map<String, dynamic>> levels = [
    {'icon': 'assets/icons/flag.png', 'unlocked': true, 'type': 'start'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
    {'icon': 'assets/icons/headphones.png', 'unlocked': false, 'type': 'listening'},
    {'icon': 'assets/icons/book.png', 'unlocked': false, 'type': 'reading'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
    {'icon': Icons.lock, 'unlocked': false, 'type': 'locked'},
    {'icon': 'assets/icons/flag.png', 'unlocked': false, 'type': 'end'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
  ];

  void changeTab(int index) {
    if (index == 0) {
      selectedIndex.value = index;
    } else {
      Get.snackbar(
        'Coming soon!', 
        'Fitur ini akan segera hadir, Pahlawan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
