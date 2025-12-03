import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/users/profile_viewmodel.dart';
import 'package:second_life/views/users/profile/edit_profil_view.dart';

class ProfileSettingsSheet {
  static void show(ProfileViewModel vm) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            const Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00775A),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Edit Profile Button
            _buildSettingsItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profil',
              subtitle: 'Ubah foto, nama, dan bio Anda',
              color: const Color(0xFF00775A),
              onTap: () {
                Get.back();
                Get.to(() => const EditProfileView());
              },
            ),
            
            const SizedBox(height: 12),
            
            // Divider
            Divider(color: Colors.grey.shade200, thickness: 1),
            
            const SizedBox(height: 12),
            
            // Logout Button
            _buildSettingsItem(
              icon: Icons.logout_rounded,
              title: 'Keluar',
              subtitle: 'Keluar dari akun Anda',
              color: Colors.red,
              onTap: () {
                Get.back();
                vm.logout();
              },
            ),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  static Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
