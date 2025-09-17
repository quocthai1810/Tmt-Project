import 'package:flutter/material.dart';
import 'package:tmt_project/src/tin_src/pages/create_new_password_page/create_new_password_page.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final Color kRedColor = const Color(0xFFFF4451);

  // tạo 4 controller cho OTP
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  void _onContinue() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // TODO: verify OTP logic
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("OTP Entered: $otp")));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => CreateNewPasswordPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter 4 digit code")),
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
            FocusScope.of(context).nextFocus();
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
        textTitle: "Verification",
        showLeading: true,
        listIcon: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
        child: Column(
          children: [
            const Text(
              "Verifying Your Account",
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
                    text: "We have just sent you 4 digit code via your\n",
                  ),
                  TextSpan(
                    text: "email example@gmail.com",
                    style: TextStyle(
                      color: Colors.white, // chữ email sáng hơn
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // OTP input row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpBox(index)),
            ),
            const SizedBox(height: 64),

            // Continue button
            CustomButton(
              width: double.infinity,
              text: "Continue",
              onPressed: _onContinue,
            ),
            const SizedBox(height: 64),

            // Resend text
            GestureDetector(
              onTap: () {},
              child: Text(
                "Didn't receive code? Resend",
                style: TextStyle(color: kRedColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
