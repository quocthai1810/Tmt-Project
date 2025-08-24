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
  /// gọi hàm này để set time cho việc chặn đứng mọi hoạt động
  /// khi sử dụng thì sẽ cho phép người dùng đó đợi ở thời gian được set: delay:

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Đây là trang home"),
          OrbitLoadingLogo(
            imageAsset: 'assets/img/logo.png',
            logoSize: 90,
            dualOpposite: true,
            orbitRadius: 70,
            dotSize: 12,
            trailCount: 10,
            trailGapDeg: 12,
            trailOpacityStart: 0.5,
            trailMinScale: 0.25,
            period: const Duration(seconds: 2),
            showOrbitRing: true,
          ),
          // 🔥 nút này đã đổi onPressed sang _navigateWithLoader
          CustomButton(
            text: "Nhấn để test Navigator sang trang test wid",
            onPressed:
                () => navigateWithOrbitLoaderNamed(
                  context,
                  imageAsset: 'assets/img/logo.png',
                  routeName: AppRouteNames.pageTestWid,
                  seconds: 3,
                ),
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
    );
  }
}
