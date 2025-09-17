import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';

import '../../../../routers/app_route.dart';

class LoginSignInPage extends StatelessWidget {
  const LoginSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/img/logo.png',
                  width: 148,
                  height: 148,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 7),
                Text(
                  "CINEMAX",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),
                Text(
                  "Enter your registered\nPhone Number to Sign Up",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Color(0xFF92929D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                CustomButton(
                  width: 327,
                  text: "Sign Up",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouteNames.signupPage);
                  },
                ),
                const SizedBox(height: 34),

                // Login text
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouteNames.loginPage);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "I already have an account? ",
                      style: const TextStyle(
                        color: Color(0xFFFFA500), // vàng cam
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            color: Color(0xFFFF4451),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Divider "Or Sign up with"
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFF252836))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Or Sign up with",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFF252836))),
                  ],
                ),

                const SizedBox(height: 32),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [GoogleButton(onTap: () {})],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget riêng cho google button
class GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GoogleButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 69,
        height: 69,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image.asset(width: 25, height: 25, "assets/img/iconGoogle.png"),
      ),
    );
  }
}
