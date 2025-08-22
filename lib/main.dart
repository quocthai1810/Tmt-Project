import 'package:flutter/material.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/entry_point_page.dart';

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
      initialRoute: AppRouteNames.entryPointPage,
      routes: appRoutes,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        //Đây là màu Chủ đề cho app ( màu Hồng cho đời đẹp :)) )
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
    );
  }
}
