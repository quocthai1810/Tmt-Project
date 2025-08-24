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
  OverlayEntry? _loaderEntry;
  Timer? _countdownTimer;

  OverlayEntry _buildLoaderEntry() {
    return OverlayEntry(
      builder:
          (_) => Stack(
            children: const [
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: ColoredBox(
                    color: Color.fromARGB(96, 0, 0, 0),
                  ), // nền đen mờ
                ),
              ),
              Positioned.fill(child: Center(child: OrbitLoadingLogo())),
            ],
          ),
    );
  }

  void _showGlobalLoader() {
    if (_loaderEntry != null) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;
    _loaderEntry = _buildLoaderEntry();
    overlay.insert(_loaderEntry!);
    setState(() => _loading = true);
  }

  void _hideGlobalLoader() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _loaderEntry?.remove();
    _loaderEntry = null;
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pushWithLoader(String routeName) async {
    if (_loading) return;

    _showGlobalLoader();

    // Đợi đúng 1s rồi mới chuyển trang
    await Future.delayed(const Duration(milliseconds: 500));

    // Push sang trang mới
    // ignore: unawaited_futures
    Navigator.of(context).pushNamed(routeName);

    // Tắt loader ngay frame kế tiếp
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('chuyển trang rồi nè, tắt loading thoi');
      _hideGlobalLoader();
    });
  }

  @override
  void dispose() {
    _hideGlobalLoader(); // dọn dẹp nếu còn
    super.dispose();
  }
  // Future<void> _pushWithLoader(String routeName) async {
  //   if (_loading) return;

  //   _showGlobalLoader();

  //   // Đếm 3 giây và in log mỗi giây
  //   int elapsed = 0;
  //   _countdownTimer?.cancel();
  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
  //     elapsed++;
  //     debugPrint('Đã trải qua $elapsed giây');

  //     if (elapsed >= 1) {
  //       t.cancel();
  //       _countdownTimer = null;

  //       // Sau 3s thì push sang trang mới
  //       // ignore: unawaited_futures
  //       Navigator.of(context).pushNamed(routeName);

  //       // Tắt overlay ngay frame tiếp theo của route mới
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         debugPrint('chuyển trang rồi nè, tắt loading thoi');
  //         _hideGlobalLoader();
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Không cần Stack overlay nữa vì loader đã chèn vào rootOverlay
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Đây là trang home"),

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
    );
  }
}
