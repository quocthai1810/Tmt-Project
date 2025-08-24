import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/routers/app_route.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Text("Đây là trang home"),
          CustomButton(
            text: "Nhấn để test Navigator sang trang test wid",
            onPressed:
                () => Navigator.pushNamed(context, AppRouteNames.pageTestWid),
            width: 300,
          ),
          CustomButton(
            text: "Thử đi cưng",
            onPressed: () => print("Anh vừa bấm đó nghen 😘"),
            width: 150,
            height: 25,
          ),
          CustomButton(
            text: "Thử đi cưng",
            onPressed: () {
              CustomToast.show(
                context,
                message: "nè bé",
                type: ToastType.success,
              );
              print("Anh vừa bấm đó nghen 😘");
            },
            width: 200,
            height: 50,
          ),
        ],
      ),
    );
  }
}
