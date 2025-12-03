import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_life/viewmodels/users/profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameC;
  late TextEditingController bioC;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final vm = Get.find<ProfileViewModel>();

    nameC = TextEditingController(text: vm.profile?.namaLengkap ?? "");
    bioC = TextEditingController(text: vm.bio);
  }

  @override
  void dispose() {
    nameC.dispose();
    bioC.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      Get.snackbar("Error", 'Error picking image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pilih Sumber Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (vm.userPhoto != null && vm.userPhoto!.isNotEmpty
                            ? MemoryImage(base64Decode(vm.userPhoto!)) as ImageProvider
                            : null),
                    child: _selectedImage == null && vm.userPhoto == null
                        ? Text(
                            vm.profile?.namaLengkap.substring(0, 2).toUpperCase() ?? "?",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF00775A),
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        onPressed: _showImageSourceDialog,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioC,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
                hintText: "Ceritakan tentang diri Anda...",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: vm.isSaving.value
                    ? null
                    : () async {
                        if (nameC.text.trim().isEmpty) {
                          Get.snackbar("Error", 'Nama tidak boleh kosong',
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        await vm.editProfile(
                          nameC.text.trim(),
                          bioC.text.trim(),
                          photoFile: _selectedImage,
                        );

                        Get.snackbar("Success", 'Profil berhasil diupdate',
                            snackPosition: SnackPosition.BOTTOM);
                        Get.back();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00775A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: vm.isSaving.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
