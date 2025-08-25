import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/customListItem.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_tabBar.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';

class SearchGenre extends StatefulWidget {
  const SearchGenre({super.key});

  @override
  State<SearchGenre> createState() => _SearchGenreState();
}

class _SearchGenreState extends State<SearchGenre> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Thể loại",
        listIcon: [],
        showLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SearchBarWidget(
              hintText: "Bạn muốn kiếm thể loại gì?",
              controller: _searchController,
              showFilter: false,
            ),
          ),
          Expanded(
            child: CustomTabBar(
              tabs: [Text("Hành động"), Text("Hài hước"), Text("Kinh dị")],
              tabViews: [
                _buildCustomListView(),
                _buildCustomListView(),
                _buildCustomListView(),
              ],
              onTabChanged: (index) {
                debugPrint("Tab được chọn: $index");
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              unselectedColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomListView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      itemCount: 5,

      /// thêm widget nếu cần nhiều phim hơn
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ListItemNgang(
            imageUrl: "https://picsum.photos/id/1005/800/500",
            title: "Spider man",
            year: 2000,
            duration: 200,
            ageRating: "16+",
            genres: ["Hành động"],
            rating: 4.5,
          ),
        );
      },
    );
  }
}
