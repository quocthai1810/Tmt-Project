import 'package:flutter/material.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: const CustomAppbar(
        textTitle: "Privacy Policy",
        showLeading: true,
        listIcon: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Section 1
            Text(
              "Terms",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. "
              "Sapien, consequat ultrices morbi orci semper sit nulla. "
              "Leo auctor ut etiam est, amet aliquet ut vivamus. "
              "Odio vulputate est id tincidunt fames.\n\n"
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. "
              "Sapien, consequat ultrices morbi orci semper sit nulla. "
              "Leo auctor ut etiam est, amet aliquet ut vivamus. "
              "Odio vulputate est id tincidunt fames.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20),

            // Section 2
            Text(
              "Changes to the Service and/or Terms:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. "
              "Sapien, consequat ultrices morbi orci semper sit nulla. "
              "Leo auctor ut etiam est, amet aliquet ut vivamus. "
              "Odio vulputate est id tincidunt fames.\n\n"
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. "
              "Sapien, consequat ultrices morbi orci semper sit nulla. "
              "Leo auctor ut etiam est, amet aliquet ut vivamus. "
              "Odio vulputate est id tincidunt fames.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
