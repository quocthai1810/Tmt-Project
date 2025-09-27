import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/src/tin_src/pages/signup_page/signup_page_provider.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';
import '../../../../core/widgets/tin/custom_loading.dart';
import '../../../../routers/app_route.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isChecked = false;

  final Color kRedColor = const Color(0xFFFF4451);

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bạn phải đồng ý để tiếp tục")),
        );
        return;
      }

      final provider = Provider.of<SignUpProvider>(context, listen: false);
      provider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Đăng ký",
        listIcon: [],
        showLeading: true,
      ),
      body: Consumer<SignUpProvider>(
        builder: (context, provider, child) {
          // nếu đăng ký thành công thì chuyển sang màn hình xác thực
          if (!provider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(
                context,
                AppRouteNames.verificationPage,
                arguments: _emailController.text.trim(),
              );
              provider.isSuccess = false;
            });
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // tiêu đề
                      Column(
                        children: const [
                          Text(
                            "Bắt đầu ngay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Những bộ phim và series mới nhất\nđang chờ bạn",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // họ và tên
                      TextFormField(
                        controller: _fullNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Họ và tên",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF2C2C3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Vui lòng nhập họ và tên" : null,
                      ),
                      const SizedBox(height: 20),

                      // email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: "Tiffanyjearsey@gmail.com",
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

                      // mật khẩu
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
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                      const SizedBox(height: 20),

                      // checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            activeColor: kRedColor,
                            onChanged: (val) {
                              setState(() {
                                _isChecked = val ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(text: "Tôi đồng ý với "),
                                  TextSpan(
                                    text: "Điều khoản dịch vụ",
                                    style: TextStyle(color: kRedColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouteNames.privacyPolicyPage,
                                        );
                                      },
                                  ),
                                  const TextSpan(text: " và "),
                                  TextSpan(
                                    text: "Chính sách bảo mật",
                                    style: TextStyle(color: kRedColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouteNames.privacyPolicyPage,
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // nút đăng ký
                      CustomButton(
                        width: double.infinity,
                        text: "Đăng ký",
                        onPressed: provider.isLoading ? null : _signUp,
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
