import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EF),
      appBar: AppBar(
        title: const Text('Dashboard Pahlawan'),
        backgroundColor: const Color(0xFF005A9C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.map,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                'Selamat Berpetualang, ${controller.currentUser?.displayName ?? "Pahlawan"}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005A9C),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${controller.currentUser?.email ?? "-"}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Quest',
                    'Mengarahkan ke quest terakhir kamu...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Mulai Quest Terakhir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
