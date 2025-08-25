import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/routers/app_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Text("Đây là trang home"),
          CustomButton(
            text: "Nhấn để test Navigator sang trang TestPage",
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.testPage);
            },
            width: 300,
          ),
        ],
      ),
    );
  }
}
