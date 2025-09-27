import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';
import '../../../../routers/app_route.dart';
import 'verification_provider.dart';

class VerificationPage extends StatefulWidget {
  final String email; // truyền email từ SignUpPage

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final Color kRedColor = const Color(0xFFFF4451);

  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());

  final List<bool> _errorStates = List.generate(4, (_) => false);

  @override
  void initState() {
    super.initState();
    // gọi API gửi OTP ngay khi vào màn hình
    Future.microtask(() {
      final provider = Provider.of<VerificationProvider>(context, listen: false);
      provider.sendOtpEmail(widget.email);
    });
  }

  void _onContinue() {
    String otp = _otpControllers.map((c) => c.text).join();

    setState(() {
      for (int i = 0; i < 4; i++) {
        _errorStates[i] = _otpControllers[i].text.isEmpty;
      }
    });

    if (otp.length == 4 && !_errorStates.contains(true)) {
      final provider = Provider.of<VerificationProvider>(context, listen: false);
      provider.verifyOtp(widget.email, otp);
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
            borderSide: BorderSide(
              color: _errorStates[index] ? Colors.red : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _errorStates[index] ? Colors.red : kRedColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              _errorStates[index] = false;
            });
          }
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
        textTitle: "Xác thực",
        showLeading: true,
        listIcon: const [],
      ),
      body: Consumer<VerificationProvider>(
        builder: (context, provider, child) {
          // nếu xác thực thành công thì qua HomePage
          if (provider.isVerified) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRouteNames.homePage, (route) => false);
              provider.isVerified = false; // reset tránh loop
            });
          }

          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
            child: Column(
              children: [
                const Text(
                  "Xác minh tài khoản",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    children: [
                      const TextSpan(text: "Chúng tôi đã gửi mã gồm 4 số qua\n"),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildOtpBox(index)),
                ),
                const SizedBox(height: 64),

                CustomButton(
                  width: double.infinity,
                  text: provider.isLoading ? "Đang xử lý..." : "Tiếp tục",
                  onPressed: provider.isLoading ? null : _onContinue,
                ),
                const SizedBox(height: 64),

                GestureDetector(
                  onTap: () {
                    provider.sendOtpEmail(widget.email);
                  },
                  child: Text(
                    "Chưa nhận được mã? Gửi lại",
                    style: TextStyle(color: kRedColor, fontSize: 14),
                  ),
                ),
                if (provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
