import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(listIcon: [], showLeading: true),
      body: Center(child: Text("Test thành công !!!"),)
    );
  }
}
