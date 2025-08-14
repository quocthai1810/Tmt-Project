import 'package:flutter/material.dart';
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
        appBar: AppBar(title: Text("Hello anh em Funny Team "),),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: 'Đây',
                borderRadius: BorderRadius.circular(12),
                onPress: () {
                  print('Button Rounded 12');
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Là',
                width: 80,
                height: 60,
                borderRadius: BorderRadius.circular(10),
                onPress: () {
                  print('Button Circle');
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Custom',
                borderRadius: BorderRadius.zero,
                onPress: () {
                  print('Button Sharp corners');
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Button',
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),
                ),
                width: 200,
                height: 50,
                onPress: () {
                  print('hihiha');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
