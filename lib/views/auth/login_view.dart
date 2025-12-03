import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/views/auth/signup_view.dart';
import 'package:second_life/viewmodels/auth/login_viewmodel.dart';
import 'package:second_life/views/auth/welcome_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(LoginViewModel());

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
                    onTap: () => Get.to(() => const WelcomeView()),
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
                        Text("Masuk ke akunmu", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => vm.toggleRole(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vm.isUser.value
                                ? const Color(0xFF00925E)
                                : Colors.grey.shade300,
                            foregroundColor:
                                vm.isUser.value ? Colors.white : Colors.black87,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text("User"),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => vm.toggleRole(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vm.isUser.value
                                ? Colors.grey.shade300
                                : const Color(0xFF00925E),
                            foregroundColor:
                                vm.isUser.value ? Colors.black87 : Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text("Admin"),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: vm.emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintText: "nama@email.com",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Password"),
                  const SizedBox(height: 5),
                  Obx(() => TextField(
                    controller: vm.passwordController,
                    obscureText: vm.obscurePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(vm.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: vm.togglePasswordVisibility,
                      ),
                      hintText: "password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                    children: [
                      Checkbox(
                        value: vm.rememberMe.value,
                        onChanged: (_) => vm.toggleRememberMe(),
                      ),
                      const Text("Ingat saya"),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => vm.goToForgot(),
                        child: const Text(
                          "Lupa password?",
                          style: TextStyle(color: Color(0xFF00925E)),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: () => vm.login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00925E),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: vm.loading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Masuk",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    )),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.to(() => const SignUpView()),
                      child: const Text.rich(
                        TextSpan(
                          text: "Belum punya akun? ",
                          children: [
                            TextSpan(
                              text: "Daftar sekarang",
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
}
