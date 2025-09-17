import 'package:flutter/material.dart';
import 'package:tmt_project/src/tin_src/pages/verification_page/verification_page.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';
import '../../../../core/widgets/tin/custom_button.dart';
import '../../../../routers/app_route.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final Color kRedColor = const Color(0xFFFF4451);

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, AppRouteNames.verificationPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: CustomAppbar(
        textTitle: "Reset Password",
        showLeading: true,
        listIcon: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title + Subtitle
              const Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Recover your account password",
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email field
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
                    return "Please enter email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Invalid email format";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Next Button
              CustomButton(
                width: double.infinity,
                text: "Next",
                onPressed: _onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
