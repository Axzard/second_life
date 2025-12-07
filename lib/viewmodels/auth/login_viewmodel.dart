import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second_life/services/auth/auth_service.dart';
import 'package:second_life/services/auth/remember_me_service.dart';
import 'package:second_life/services/auth/user_service.dart';
import 'package:second_life/services/auth/user_status_service.dart';
import 'package:second_life/models/auth/user_model.dart';
import 'package:second_life/views/admin/admin_dashboard_view.dart';
import 'package:second_life/views/auth/forgot_password_view.dart';
import 'package:second_life/views/users/home_user_view.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final UserStatusService _statusService = UserStatusService();
  final RememberMeService _rememberService = RememberMeService();

  var obscurePassword = true.obs;
  var loading = false.obs;
  var isUser = true.obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRememberedLogin();
  }

  Future<void> loadRememberedLogin() async {
    final data = await _rememberService.getLoginData();
    rememberMe.value = data['remember'];
    emailController.text = data['email'];
    passwordController.text = data['password'];
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRole(bool userRole) {
    isUser.value = userRole;
  }

  void goToForgot() {
    Get.to(() => const ForgotPasswordView());
  }

  void back() {
    Get.back();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      showMessage("Email & password harus diisi");
      return;
    }

    try {
      final User? user = await _authService.login(email, pass);
      if (user == null) {
        showMessage("Login gagal");
        return;
      }

      if (rememberMe.value) {
        await _rememberService.saveLoginData(email, pass);
      } else {
        await _rememberService.clearLoginData();
      }

      final UserModel? userData = await _userService.getUserById(user.uid);

      if (userData == null) {
        await FirebaseAuth.instance.signOut();
        showMessage("Data user tidak ditemukan");
        return;
      }

      final status = (userData.status).toString().toLowerCase();
      if (status != "aktif") {
        await FirebaseAuth.instance.signOut();
        await _rememberService.clearLoginData();
        showMessage("Anda sudah di banned oleh admin");
        return;
      }

      if (isUser.value && userData.role != "user") {
        showMessage("Silakan Login Sebagai Admin");
        return;
      }

      if (!isUser.value && userData.role != "admin") {
        showMessage("Silakan Login Sebagai User");
        return;
      }

      if (userData.role == "admin") {
        Get.off(() => const HomeAdminView());
      } else {
        Get.off(() => const HomeUserView());
      }

      await _statusService.setUserOnline();
      showMessage("Login berhasil");
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "Login error");
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void showMessage(String msg) {
    Get.snackbar(
      "Info",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Color(0xFF00775A),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
