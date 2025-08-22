import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_list_item_horizontal.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(listIcon: [], showLeading: true),
      body: Container(
        height: 300,
        child: CustomListItemHorizontal(
          items: [
            CustomListItemHorizontal.createMovieItem(
              title: "title",
              genre: "genre",
              rating: "rating",
              reviewCount: 1,
            ),
            CustomListItemHorizontal.createMovieItem(
              title: "title",
              genre: "genre",
              rating: "rating",
              reviewCount: 1,
            ),
            CustomListItemHorizontal.createMovieItem(
              title: "title",
              genre: "genre",
              rating: "rating",
              reviewCount: 1,
            ),
            CustomListItemHorizontal.createMovieItem(
              title: "title",
              genre: "genre",
              rating: "rating",
              reviewCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
