import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/minh/customCarousel.dart';
import 'package:tmt_project/core/widgets/minh/customListItem.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';
import 'package:tmt_project/src/thai_src/widget/custom_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  /// phim sắp ra mắt lấy backend là bỏ vô
  final List<Map<String, dynamic>> upcomingMovies = [
    {
      "imageUrl": "https://i.ibb.co/0qPq9yF/wakanda.jpg",
      "title": "Black Panther",
      "genre": "Hành động",
      "rating": 4.5,
    },
    {
      "imageUrl": "https://i.ibb.co/0qPq9yF/wakanda.jpg",
      "title": "Doctor Strange",
      "genre": "Fantasy",
      "rating": 4.2,
    },
    {
      "imageUrl": "https://i.ibb.co/0qPq9yF/wakanda.jpg",
      "title": "Thor: Love and Thunder",
      "genre": "Adventure",
      "rating": 4.0,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        listIcon: [
          CustomIcon(
            iconData: Icons.notifications,
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.notificationPage);
            },
          ),
        ],
        showLeading: false,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          SearchBarWidget(
            controller: _searchController,
            onFilterTap: () {
              Navigator.pushNamed(context, AppRouteNames.filterPage);
            },
            onChanged: (value) {
              // xử lý search real-time
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSectionHeader(title: "Phim phổ biến", isTap: false),
                  CustomCarousel(
                    movies: [
                      Movie(
                        imageUrl: "https://picsum.photos/id/1027/800/500",
                        title: "Hành Trình Vũ Trụ",
                        releaseDate: DateTime(2025, 8, 20),
                        isSneakshow: true,
                        is16Plus: false,
                        genres: ["Hoạt hình", "Phiêu lưu", "Gia đình"],
                        topRank: 1,
                      ),
                      Movie(
                        imageUrl: "https://picsum.photos/id/1015/800/500",
                        title: "Bí Ẩn Rừng Sâu",
                        releaseDate: DateTime(2025, 7, 10),
                        isSneakshow: false,
                        is16Plus: true,
                        genres: ["Kinh dị", "Ly kỳ"],
                        topRank: 2,
                      ),
                      Movie(
                        imageUrl: "https://picsum.photos/id/1003/800/500",
                        title: "Cuộc Chiến Thời Gian",
                        releaseDate: DateTime(2025, 6, 5),
                        isSneakshow: true,
                        is16Plus: true,
                        genres: ["Hành động", "Khoa học viễn tưởng"],
                        topRank: 3,
                      ),
                    ],
                  ),

                  /// Phim sắp ra mắt
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
                        CustomSectionHeader(
                          title: "Phim sắp ra mắt",
                          /// upcoming_page.dart
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteNames.upcomingPage,
                            );
                          },
                        ),
                        // Danh sách phim sắp ra mắt
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingMovies.length,
                            itemBuilder: (context, index) {
                              final movie = upcomingMovies[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ListItemDoc(
                                  imageUrl: movie["imageUrl"],
                                  title: movie["title"],
                                  genre: movie["genre"],
                                  rating: movie["rating"],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
                        /// Phim đang chiếu
                        CustomSectionHeader(
                          title: "Phim đang chiếu",
                          /// showing_page.dart
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouteNames.showingPage,
                            );
                          },
                        ),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingMovies.length,
                            itemBuilder: (context, index) {
                              final movie = upcomingMovies[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ListItemDoc(
                                  imageUrl: movie["imageUrl"],
                                  title: movie["title"],
                                  genre: movie["genre"],
                                  rating: movie["rating"],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
