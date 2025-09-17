import 'package:flutter/material.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  // Kiểm tra mật khẩu cũ
  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) return "Mật khẩu cũ không được để trống";
    return null;
  }

  // Kiểm tra mật khẩu mới
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Mật khẩu không được để trống";
    if (value.length < 6) return "Mật khẩu phải >= 6 ký tự";
    return null;
  }

  // Kiểm tra nhập lại mật khẩu
  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) return "Mật khẩu không khớp";
    return null;
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Mật khẩu không khớp ❌")));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt lại mật khẩu thành công ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Tạo mật khẩu mới",
        showLeading: true,
        listIcon: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Tạo mật khẩu mới",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Nhập mật khẩu mới của bạn",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 40),

              // Mật khẩu cũ
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _isObscureOld,
                validator: _validateOldPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mật khẩu cũ",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureOld ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureOld = !_isObscureOld;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mật khẩu mới
              TextFormField(
                controller: _newPasswordController,
                obscureText: _isObscureNew,
                validator: _validatePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mật khẩu mới",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureNew ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureNew = !_isObscureNew;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Xác nhận mật khẩu
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                validator: _validateConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Xác nhận mật khẩu",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Nút Đặt lại
              CustomButton(
                width: double.infinity,
                text: "Đặt lại",
                onPressed: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}