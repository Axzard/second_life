import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:second_life/viewmodels/users/profile_viewmodel.dart';
import 'package:second_life/views/users/profile/widgets/profile_settings_sheet.dart';
import 'package:second_life/views/users/profile/widgets/profile_widgets.dart';
import 'package:second_life/views/users/profile/widgets/profile_edit_dialog.dart';
import 'package:second_life/views/users/profile/widgets/profile_image_picker.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(ProfileViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() => Skeletonizer(
        enabled: vm.loading.value,
        child: Column(
          children: [
            _buildHeader(vm),
            _buildStats(vm),
            _buildTabBar(vm),
            Expanded(child: _buildTabContent(vm)),
          ],
        ),
      )),
    );
  }

  Widget _buildHeader(ProfileViewModel vm) {
    return Obx(() {
      final profilePhoto = vm.user.value?.profilePhoto ?? '';
      final userName = vm.user.value?.namaLengkap ?? 'User Name Loading';
      final userEmail = vm.user.value?.email ?? 'user@email.com';
      final userBio = vm.user.value?.bio ?? '';

      return Container(
        color: const Color(0xFF00775A),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: vm.loading.value ? null : () => Get.back(),
                    ),
                    const Text(
                      'Profil Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: vm.loading.value ? null : () => ProfileSettingsSheet.show(vm),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: vm.loading.value ? null : () => ProfileImagePicker.show(vm),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: profilePhoto.isNotEmpty && !vm.loading.value
                                ? MemoryImage(base64Decode(profilePhoto))
                                : null,
                            child: profilePhoto.isEmpty || vm.loading.value
                                ? const Icon(Icons.person, size: 50, color: Color(0xFF00775A))
                                : null,
                          ),
                          if (!vm.loading.value)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Color(0xFF00775A),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                    if (userBio.isNotEmpty || vm.loading.value) ...[
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vm.loading.value ? 'Bio pengguna akan muncul disini' : userBio,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStats(ProfileViewModel vm) {
    return Obx(() {
      final allProducts = [...vm.myProducts, ...vm.soldProducts];
      final soldCount = vm.soldProducts.length;
      final availableCount = vm.myProducts.length;

      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ProfileWidgets.buildStatCard(
                vm.loading.value ? '0' : allProducts.length.toString(),
                "Produk Saya",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileWidgets.buildStatCard(
                vm.loading.value ? '0' : soldCount.toString(),
                "Terjual",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileWidgets.buildStatCard(
                vm.loading.value ? '0' : availableCount.toString(),
                "Tersedia",
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabBar(ProfileViewModel vm) {
    return Obx(() => Container(
      color: Colors.white,
      child: Row(
        children: [
          ProfileWidgets.buildTabButton(
            "Produk Saya",
            Icons.inventory_2_outlined,
            0,
            vm.selectedTab.value,
            vm.loading.value ? (_) {} : vm.selectTab,
          ),
          ProfileWidgets.buildTabButton(
            "Terjual",
            Icons.check_circle_outline,
            1,
            vm.selectedTab.value,
            vm.loading.value ? (_) {} : vm.selectTab,
          ),
        ],
      ),
    ));
  }

  Widget _buildTabContent(ProfileViewModel vm) {
    return Obx(() {
      if (vm.loading.value) {
        return _buildSkeletonList();
      }
      
      if (vm.selectedTab.value == 0) {
        return _buildMyProductsTab(vm);
      } else {
        return _buildSoldProductsTab(vm);
      }
    });
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Bone.square(
                size: 80,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 3),
                    const SizedBox(height: 8),
                    Bone.text(words: 2),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyProductsTab(ProfileViewModel vm) {
    if (vm.myProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "Belum ada produk",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.myProducts.length,
      itemBuilder: (context, index) {
        final product = vm.myProducts[index];
        final images = product["images"] ?? [];
        final firstImage = images.isNotEmpty ? images[0] : "";

        return ProfileWidgets.buildProductCard(
          firstImage,
          product["name"] ?? "Tanpa Nama",
          product["price"] ?? "Rp 0",
          product["status"] ?? "Tersedia",
          () => ProfileEditDialog.show(vm, product),
          () => _confirmDelete(vm, product["id"]),
        );
      },
    ));
  }

  Widget _buildSoldProductsTab(ProfileViewModel vm) {
    if (vm.soldProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "Belum ada produk yang terjual",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.soldProducts.length,
      itemBuilder: (context, index) {
        final product = vm.soldProducts[index];
        final images = product["images"] ?? [];
        final firstImage = images.isNotEmpty ? images[0] : "";

        return ProfileWidgets.buildProductCard(
          firstImage,
          product["name"] ?? "Tanpa Nama",
          product["price"] ?? "Rp 0",
          product["status"] ?? "Terjual",
          () => ProfileEditDialog.show(vm, product),
          () => _confirmDelete(vm, product["id"]),
        );
      },
    ));
  }

  void _confirmDelete(ProfileViewModel vm, String productId) {
    Get.defaultDialog(
      title: "Hapus Produk",
      middleText: "Apakah Anda yakin ingin menghapus produk ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        vm.deleteProduct(productId);
        Get.back();
      },
    );
  }
}
