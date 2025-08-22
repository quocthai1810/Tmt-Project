import 'package:flutter/material.dart';

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
