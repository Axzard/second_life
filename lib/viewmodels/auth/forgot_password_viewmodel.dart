import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/services/auth/auth_service.dart';

class ForgotPasswordViewModel extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _authService.forgotPassword(email);

      Get.snackbar(
        "Success",
        "Link reset password telah dikirim",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: const Color(0xFF00775A),
        borderRadius: 12,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
