// Làm đi Minh nèeeeeeeeeeee
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tmt_project/core/widgets/minh/customCarousel.dart';
import 'package:tmt_project/core/widgets/minh/customCheckbox.dart'; // ScrollDirection

/// =================== DOMAIN MODEL ===================

class codeDiMinhoi extends StatefulWidget {
  const codeDiMinhoi({super.key});

  @override
  State<codeDiMinhoi> createState() => _codeDiMinhoiState();
}

class _codeDiMinhoiState extends State<codeDiMinhoi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const UseCustomCarousel(),
            const SizedBox(height: 24),
            CustomCheckbox(
              initialValue: false,
              onChanged: (value) {
                print("✅ Checked: $value");
              },
            ),
          ],
        ),
      ),
    );
  }
}
