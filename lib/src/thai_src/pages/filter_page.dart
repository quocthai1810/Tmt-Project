import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_radioBtn.dart';
import 'package:tmt_project/routers/app_route.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedCategory = 1;
  // options text
  final Map<int, String> categories = {
    1: "Action",
    2: "Horror",
    3: "Fantasy",
    4: "Anime",
  };
  // background image url
  final Map<int, String> categoryImages = {
    1: "https://picsum.photos/id/1005/800/500",
    2: "https://picsum.photos/id/1005/800/500",
    3: "https://picsum.photos/id/1005/800/500",
    4: "https://picsum.photos/id/1005/800/500",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Thể loại",
        listIcon: [],
        showLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomRadioButton(
          options: categories,
          selectedValue: selectedCategory,
          //cần hỏi lại chỗ này
          onChanged: (val) => setState(() => selectedCategory = val),
          images: categoryImages,
          onItemTap: (value) {
            Navigator.pushNamed(context, AppRouteNames.searchGenrePage);
          },
        ),
      ),
    );
  }
}
