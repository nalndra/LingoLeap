import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  // Design constants
  static const _bgColor = Color(0xFFFCFAED);
  static const _blue = Color(0xFF2977C7);
  static const _green = Color(0xFF3DAA4C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ───
                _buildHeader(),
                const SizedBox(height: 32),

                // ─── Avatar Card ───
                _buildAvatarCard(),
                const SizedBox(height: 32),

                // ─── Name Field ───
                _buildNameField(),
                const SizedBox(height: 32),

                // ─── Save Button ───
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button — blue circle
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: _blue,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Image.asset('assets/icons/back.png', width: 22, height: 22, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Edit Profil',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _blue,
                  height: 31.2 / 24,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 46), // Balance the back button
      ],
    );
  }

  Widget _buildAvatarCard() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.10),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            Obx(() {
              final picked = controller.pickedFile.value;
              final url    = controller.photoUrl.value;

              Widget image;
              if (picked != null) {
                image = ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.file(File(picked.path),
                      width: 100, height: 100, fit: BoxFit.cover),
                );
              } else if (url.isNotEmpty) {
                image = ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(url,
                      width: 100, height: 100, fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) => _defaultAvatar()),
                );
              } else {
                image = _defaultAvatar();
              }

              return Stack(
                children: [
                  image,
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.pickImage,
              child: Text(
                'Ubah Foto',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _green,
                  decoration: TextDecoration.underline,
                  decorationColor: _green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 56, color: Colors.white),
      ),
    );
  }

  Widget _buildNameField() {
    return Obx(() {
      final isParent = controller.isParent.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            isParent ? 'Nama Orang Tua' : 'Nama Pahlawan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),

          // Text field with edit icon
          TextField(
            controller: controller.nameController,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF333333),
            ),
            decoration: InputDecoration(
              hintText: isParent
                  ? 'Masukan nama Orang tua'
                  : 'Siapa namamu, Pahlawan?',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              suffixIcon: Icon(Icons.edit_outlined, color: Colors.grey[500]),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: _blue, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSaveButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                controller.isLoading.value ? null : controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              disabledBackgroundColor: _blue.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
              shadowColor: _blue.withValues(alpha: 0.4),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ));
  }
}
