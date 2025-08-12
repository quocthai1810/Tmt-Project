import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/code_di.dart';
import 'package:tmt_project/core/widgets/thai/CustomButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        //Đây là màu Chủ đề cho app ( màu Hồng cho đời đẹp :)) )
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 156, 82, 93),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Hello anh em Funny Team ")),
        body: codeDiMinhoi(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
