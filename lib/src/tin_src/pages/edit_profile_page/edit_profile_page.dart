import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isObscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email") ?? "";

    String nameFromEmail(String e) {
      final at = e.indexOf("@");
      return at >= 0 ? e.substring(0, at) : e;
    }

    setState(() {
      _emailController.text = email.isNotEmpty ? email : "Chưa có email";
      _nameController.text = email.isNotEmpty ? nameFromEmail(email) : "Người dùng";
      _phoneController.text = "+84"; // hoặc load từ prefs nếu có
    });
  }

  // validate
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Tên không được để trống";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email không được để trống";
    if (!value.contains("@")) return "Email không hợp lệ";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Mật khẩu không được để trống";
    if (value.length < 6) return "Mật khẩu phải >= 6 ký tự";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Số điện thoại không được để trống";
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return "Số điện thoại không hợp lệ";
    }
    return null;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(content: Text("Cập nhật hồ sơ thành công ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Chỉnh sửa hồ sơ",
        listIcon: [],
        showLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar + nút sửa
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/img/logo.png"),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đổi ảnh đại diện"),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                _nameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                _emailController.text,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Họ và tên
              TextFormField(
                controller: _nameController,
                validator: _validateName,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Họ và tên",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email (readonly vì thường email cố định)
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                readOnly: true, // không cho sửa
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscurePassword,
                validator: _validatePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePassword = !_isObscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Số điện thoại
              TextFormField(
                controller: _phoneController,
                validator: _validatePhone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF2C2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Nút lưu thay đổi
              CustomButton(
                width: double.infinity,
                text: "Lưu thay đổi",
                onPressed: _saveChanges,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
