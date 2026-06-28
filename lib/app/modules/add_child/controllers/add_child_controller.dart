import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AddChildController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> findAndLinkChild() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || name.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Nama Pahlawan wajib diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: 'child')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar(
          'Tidak Ditemukan',
          'Tidak ada akun anak dengan email tersebut.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final childDoc = querySnapshot.docs.first;
      final childData = childDoc.data();
      final childName = childData['name']?.toString() ?? '';

      if (childName.toLowerCase() != name.toLowerCase()) {
        Get.snackbar(
          'Tidak Cocok',
          'Nama Pahlawan tidak sesuai dengan email tersebut.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (childData['parentId'] != null && childData['parentId'] != _auth.currentUser?.uid) {
         Get.snackbar(
          'Gagal',
          'Akun anak ini sudah terhubung ke orang tua lain.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Show Confirmation Dialog
      _showConfirmationDialog(childData, childDoc.id);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mencari akun.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showConfirmationDialog(Map<String, dynamic> childData, String childUid) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Konfirmasi Tambah Anak',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2977C7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            childData['name'] ?? 'Anak',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2977C7),
                            ),
                          ),
                          Text(
                            'Level ${childData['level'] ?? 1} • ${childData['xp'] ?? 0} XP',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF2977C7).withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _linkChildToParent(childUid, childData['name'] ?? 'Anak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2977C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ya, Tambahkan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB4B4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _linkChildToParent(String childUid, String childName) async {
    try {
      Get.back(); // close dialog
      isLoading.value = true;
      final parentUid = _auth.currentUser?.uid;
      
      if (parentUid != null) {
        // Update child document with parentId
        await _firestore.collection('users').doc(childUid).update({
          'parentId': parentUid,
        });

        Get.snackbar(
          'Berhasil',
          '$childName berhasil dihubungkan ke Dasbor Anda.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Go back to settings
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menghubungkan anak.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
