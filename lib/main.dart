import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_BottomNavBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_listTile.dart';
import 'package:tmt_project/core/widgets/thai/custom_radioBtn.dart';
import 'package:tmt_project/core/widgets/thai/custom_tabBar.dart';
import 'package:tmt_project/core/widgets/thai/toggle_Switch/custom_toggle_1.dart';
import 'package:tmt_project/core/widgets/thai/toggle_Switch/custom_toggle_2.dart';
import 'package:tmt_project/core/widgets/thai/toggle_Switch/custom_toggle_3.dart';
import 'package:tmt_project/core/widgets/thai/toggle_Switch/custom_toggle_4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        //Đây là màu Chủ đề cho app ( màu Hồng cho đời đẹp :)) )
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        
      ),
      home: Placeholder(),
    );
  }
}
