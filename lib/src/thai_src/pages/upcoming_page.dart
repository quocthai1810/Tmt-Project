import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/custom_item_vertical.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';

class UpcomingMoviesPage extends StatefulWidget {
  const UpcomingMoviesPage({super.key});

  @override
  State<UpcomingMoviesPage> createState() => _UpcomingMoviesPageState();
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> movies = [
    {
      "imageUrl": "https://picsum.photos/id/1027/800/500",
      "title": "Spider Man",
      "genre": "Hành động",
      "rating": 4.5,
    },
    {
      "imageUrl": "https://picsum.photos/id/1035/800/500",
      "title": "Avengers",
      "genre": "Viễn tưởng",
      "rating": 4.8,
    },
    {
      "imageUrl": "https://picsum.photos/id/1042/800/500",
      "title": "Batman",
      "genre": "Tội phạm",
      "rating": 4.6,
    },
    {
      "imageUrl": "https://picsum.photos/id/1051/800/500",
      "title": "Iron Man",
      "genre": "Siêu anh hùng",
      "rating": 4.7,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Phim sắp ra mắt",
        listIcon: [],
        showLeading: true,
      ),
      body: Column(
        children: [
          SearchBarWidget(controller: _searchController, showFilter: false),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.67,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return CustomItemVertical(
                  imageUrl: movie["imageUrl"],
                  title: movie["title"],
                  genre: movie["genre"],
                  rating: movie["rating"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
