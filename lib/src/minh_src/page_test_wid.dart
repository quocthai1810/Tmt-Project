import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';

class PageTestWid extends StatefulWidget {
  const PageTestWid({super.key});

  @override
  State<PageTestWid> createState() => _PageTestWidState();
}

class _PageTestWidState extends State<PageTestWid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(listIcon: [], showLeading: true),
      body: Center(child: Text("Test wid !!!")),
    );
  }
}
