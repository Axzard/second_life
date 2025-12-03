import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/auth/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(SignUpViewModel());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00925E), Color(0xFF00775A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8),
                        Text("Kembali"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: const [
                        Icon(Icons.autorenew, size: 40, color: Color(0xFF00925E)),
                        SizedBox(height: 5),
                        Text(
                          "Second Life",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00925E),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("Buat akun barumu", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text("Nama Lengkap"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: vm.namaLengkapController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration("nama lengkap", icon: Icons.person),
                  ),
                  const SizedBox(height: 15),
                  const Text("Email"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: vm.emailController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration("email@email.com", icon: Icons.email_outlined),
                  ),
                  const SizedBox(height: 15),
                  const Text("Password"),
                  const SizedBox(height: 5),
                  Obx(() => TextField(
                    controller: vm.passwordController,
                    obscureText: vm.obscurePassword.value,
                    decoration: _inputDecoration(
                      "Minimal 8 karakter",
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(vm.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: vm.toggleObscurePassword,
                      ),
                    ),
                  )),
                  const SizedBox(height: 15),
                  const Text("Konfirmasi Password"),
                  const SizedBox(height: 5),
                  Obx(() => TextField(
                    controller: vm.confirmPasswordController,
                    obscureText: vm.obscureConfirmPassword.value,
                    decoration: _inputDecoration(
                      "Ulangi password",
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(vm.obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: vm.toggleObscureConfirmPassword,
                      ),
                    ),
                  )),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: vm.isLoading.value ? null : () => vm.register(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00925E),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: vm.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Daftar",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    )),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text.rich(
                        TextSpan(
                          text: "Sudah punya akun? ",
                          children: [
                            TextSpan(
                              text: "Masuk sekarang",
                              style: TextStyle(
                                color: Color(0xFF00925E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
