import 'package:flutter/material.dart';
import 'package:tmt_project/src/tin_src/pages/create_new_password_page/create_new_password_page.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';
import '../../../../routers/app_route.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final Color kRedColor = const Color(0xFFFF4451);

  // tạo 4 ô nhập cho mã OTP
  final List<TextEditingController> _otpControllers = List.generate(
    4,
        (_) => TextEditingController(),
  );

  void _onContinue() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // TODO: gọi API xác thực OTP
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Mã OTP: $otp")));
      Navigator.pushNamed(context, AppRouteNames.createNewPasswordPage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 4 số OTP")),
      );
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(color: Colors.white, fontSize: 22),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFF2C2C3E),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus(); // tự nhảy sang ô kế tiếp
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Xác thực", // Verification
        showLeading: true,
        listIcon: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
        child: Column(
          children: [
            const Text(
              "Xác minh tài khoản", // Verifying Your Account
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.white70),
                children: [
                  TextSpan(
                    text: "Chúng tôi đã gửi mã gồm 4 số qua\n", // We have just sent you 4 digit code via your
                  ),
                  TextSpan(
                    text: "email example@gmail.com", // email example@gmail.com
                    style: TextStyle(
                      color: Colors.white, // chữ email sáng hơn
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Hàng nhập mã OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpBox(index)),
            ),
            const SizedBox(height: 64),

            // Nút Tiếp tục
            CustomButton(
              width: double.infinity,
              text: "Tiếp tục", // Continue
              onPressed: _onContinue,
            ),
            const SizedBox(height: 64),

            // Gửi lại mã
            GestureDetector(
              onTap: () {},
              child: Text(
                "Chưa nhận được mã? Gửi lại", // Didn't receive code? Resend
                style: TextStyle(color: kRedColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
