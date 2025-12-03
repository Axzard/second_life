import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:second_life/models/auth/user_model.dart';
import 'package:second_life/services/auth/auth_service.dart';
import 'package:second_life/services/auth/user_service.dart';

class SignUpViewModel extends GetxController {
  final namaLengkapController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var isLoading = false.obs;

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> register() async {
    final nama = namaLengkapController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (nama.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      showMessage("Semua field wajib diisi");
      return;
    }

    if (pass != confirm) {
      showMessage("Password tidak sama");
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authService.register(email, pass);
      if (user == null) throw Exception("Register gagal!");

      final String bergabung = DateFormat("MMMM yyyy").format(DateTime.now());

      final userModel = UserModel(
        uid: user.uid,
        namaLengkap: nama,
        email: email,
        role: "user",
        status: "aktif",
        bergabung: bergabung,
      );

      await _userService.saveUserData(userModel);

      isLoading.value = false;

      showMessage("Registrasi berhasil!");
      Get.back();
    } catch (e) {
      isLoading.value = false;
      showMessage(e.toString());
    }
  }

  void showMessage(String msg) {
    Get.snackbar(
      "Info",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: const Color(0xFF00775A),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    namaLengkapController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
