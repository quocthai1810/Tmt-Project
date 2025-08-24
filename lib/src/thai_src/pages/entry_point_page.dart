import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_BottomNavBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/src/thai_src/pages/home_page.dart';
import 'package:tmt_project/src/thai_src/pages/news_page.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page.dart';
import 'package:tmt_project/src/thai_src/pages/user_page.dart';
import 'package:tmt_project/core/widgets/tin/custom_progress_indicator.dart';

class EntryPointPage extends StatefulWidget {
  const EntryPointPage({super.key});

  @override
  State<EntryPointPage> createState() => _EntryPointPageState();
}

class _EntryPointPageState extends State<EntryPointPage> {
  int initialIndex = 0;
  bool _loading = false;
  final listIcons = [
    Icons.home,
    Icons.theater_comedy,
    Icons.newspaper,
    Icons.person,
  ];
  final listPages = [HomePage(), TheaterPage(), NewsPage(), UserPage()];
  Future<void> _onTabTapped(int index) async {
    if (_loading || index == initialIndex) return;
    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      setState(() {
        initialIndex = index;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppbar(
            listIcon: [
              CustomIcon(iconData: Icons.notifications, onPressed: () {}),
            ],
            showLeading: false,
          ),
          body: IndexedStack(index: initialIndex, children: listPages),
          bottomNavigationBar: CustomBottomnavbar(
            currentIndex: initialIndex,
            onTap: _onTabTapped,
            items: listIcons,
            pages: listPages,
          ),
        ),
        if (_loading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color.fromARGB(137, 26, 26, 26),
              child: Center(
                child: OrbitLoadingLogo(
                  imageAsset: 'assets/img/logo.png',
                  logoSize: 90,
                  dualOpposite: true,
                  orbitRadius: 70,
                  dotSize: 12,
                  trailCount: 10,
                  trailGapDeg: 12,
                  trailOpacityStart: 0.5,
                  trailMinScale: 0.25,
                  showOrbitRing: false,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
