import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_BottomNavBar.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/news_page.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page/theater_page.dart';
import 'package:tmt_project/src/thai_src/pages/user_page.dart';

class EntryPointPage extends StatefulWidget {
  const EntryPointPage({super.key});

  @override
  State<EntryPointPage> createState() => _EntryPointPageState();
}

class _EntryPointPageState extends State<EntryPointPage> {
  int initialIndex = 0;
  final listIcons = [
    Icons.home,
    Icons.theater_comedy,
    Icons.newspaper,
    Icons.person,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final listPages = [HomePage(), TheaterPage(), NewsPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: initialIndex, children: listPages),
      bottomNavigationBar: CustomBottomnavbar(
        currentIndex: initialIndex,
        onTap:
            (index) => setState(() {
              initialIndex = index;
            }),
        items: listIcons,
        pages: listPages,
      ),
    );
  }
}
