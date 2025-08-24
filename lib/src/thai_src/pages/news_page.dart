import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/core/widgets/tin/custom_progress_indicator.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'dart:async';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _loading = false;

  Future<void> _pushWithLoader(String routeName) async {
    if (_loading) return; // tránh double tap
    setState(() => _loading = true);

    try {
      await Navigator.pushNamed(context, routeName);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Đây là trang home"),

              // Nếu muốn show demo loader nằm TRONG layout thì để dòng dưới.
              // Còn overlay loader đã có ở cuối Stack nên không cần cái này.
              // const OrbitLoadingLogo(),

              // ✅ Nút điều hướng: bật overlay + push ngay
              CustomButton(
                text: "Nhấn để test Navigator sang trang test wid",
                onPressed: () => _pushWithLoader(AppRouteNames.pageTestWid),
                width: 300,
              ),

              CustomButton(
                text: "Thử đi cưng",
                onPressed: () => debugPrint("Anh vừa bấm đó nghen 😘"),
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
                  debugPrint("Anh vừa bấm đó nghen 😘");
                },
                width: 200,
                height: 50,
              ),
            ],
          ),
        ),

        // 🛡️ Overlay loader: phủ đen + khóa mọi tương tác
        if (_loading) const OrbitLoadingLogo(),
      ],
    );
  }
}
