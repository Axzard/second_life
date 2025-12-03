import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_life/viewmodels/users/profile_viewmodel.dart';

class ProfileImagePicker {
  static Future<void> show(ProfileViewModel vm) async {
    final ImagePicker picker = ImagePicker();

    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pilih Sumber Foto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF00775A)),
              title: const Text("Kamera"),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );
                if (image != null) {
                  final bytes = await File(image.path).readAsBytes();
                  final base64String = base64Encode(bytes);
                  await vm.updateProfilePhoto(base64String);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF00775A)),
              title: const Text("Galeri"),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );
                if (image != null) {
                  final bytes = await File(image.path).readAsBytes();
                  final base64String = base64Encode(bytes);
                  await vm.updateProfilePhoto(base64String);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
