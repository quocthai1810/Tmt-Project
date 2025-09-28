import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/src/thai_src/widget/custom_profile.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
            username: "Quốc Thái",
            email: "thai@gmail.com",
            avatarUrl: "https://picsum.photos/id/1005/800/500",
          ),
          CustomButton(text: "Đăng xuất", onPressed: () {}),
        ],
      ),
    );
  }
}
