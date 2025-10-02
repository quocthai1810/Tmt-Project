import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';
import '../../../../core/widgets/tin/custom_loading.dart';
import '../../../../routers/app_route.dart';
import 'login_page_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Đăng nhập",
        listIcon: [],
        showLeading: true,
      ),
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          // khi login thành công thì điều hướng sang HomePage
          if (provider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouteNames.entryPointPage,
                (route) => false, // xoá toàn bộ route trước đó
              );
              provider.isSuccess = false;
            });
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "TMT Xin chào",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Chào mừng quay lại! Vui lòng nhập\nthông tin của bạn.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 62),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: "TmtAppTeam@gmail.com",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF2C2C3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Email không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Mật khẩu
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF2C2C3E),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập mật khẩu";
                          }
                          if (value.length < 6) {
                            return "Mật khẩu phải có ít nhất 6 ký tự";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Nút đăng nhập
                      CustomButton(
                        width: double.infinity,
                        text: "Đăng nhập",
                        onPressed:
                            provider.isLoading ? null : () => _login(context),
                      ),

                      if (provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // overlay loading
              if (provider.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CustomLoading(width: 88, height: 88),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
