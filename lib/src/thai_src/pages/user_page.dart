import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/src/thai_src/widget/custom_profile.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? _username;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email") ?? "";

    setState(() {
      _email = email.isNotEmpty ? email : "Chưa có email";
      // 👉 lấy phần trước @ làm username
      if (email.contains("@")) {
        _username = email.split("@")[0];
      } else {
        _username = "Người dùng";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Thông tin cá nhân",
        listIcon: [],
        showLeading: false,
      ),
      body: Column(
        children: [
          CustomProfile(
            username: _username ?? "Người dùng",
            email: _email ?? "Đang tải...",
            avatarUrl: "https://picsum.photos/id/1005/800/500",
          ),
          CustomButton(
            text: "Đăng xuất",
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
