import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/minh/customCarousel.dart';
import 'package:tmt_project/core/widgets/minh/custom_item_vertical.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page_provider.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';
import 'package:tmt_project/src/thai_src/widget/custom_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearchResult = false;
  final List<Map<String, dynamic>> actors = [
    {
      "name": "John Wilson",
      "imageUrl": "https://picsum.photos/id/1027/800/500",
    },
    {"name": "John Cena", "imageUrl": "https://picsum.photos/id/1027/800/500"},
    {
      "name": "John Stamos",
      "imageUrl": "https://picsum.photos/id/1027/800/500",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code này sẽ chạy sau khi build widget xong
      context.read<MovieProvider>().layPhimDangChieu();
      context.read<MovieProvider>().layPhimSapRaMat();
    });

    _searchController.addListener(() {
      setState(() {
        showSearchResult = _searchController.text.isNotEmpty;
      });
    });
  }

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
      body: Stack(
        children: [
          Column(
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
                            imageUrl: "https://picsum.photos/id/1027/800/500",
                            title: "Hành Trình Vũ Trụ",
                            releaseDate: DateTime(2025, 8, 20),
                            isSneakshow: true,
                            is16Plus: false,
                            genres: ["Hoạt hình", "Phiêu lưu", "Gia đình"],
                            topRank: 2,
                          ),
                        ],
                      ),

                      /// Phim đang chiếu
                      Container(
                        height: 360,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        child: Column(
                          children: [
                            CustomSectionHeader(
                              title: "Phim đang chiếu",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteNames.showingPage,
                                );
                              },
                            ),
                            Expanded(
                              child: Consumer<MovieProvider>(
                                builder: (context, value, child) {
                                  if (value.error != null) {
                                    return Center(
                                      child: Text(value.error ?? ""),
                                    );
                                  }
                                  return value.isLoading == false
                                      ? value.moviesDangChieu.isEmpty
                                          ? const Text("Chưa có phim")
                                          : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                value.moviesDangChieu.length,
                                            itemBuilder: (context, index) {
                                              final movie =
                                                  value.moviesDangChieu[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: CustomItemVertical(
                                                  idMovie:
                                                      movie["ma_phim"] ?? 0,
                                                  imageUrl:
                                                      movie["anh_poster"] ?? "",
                                                  title:
                                                      movie["ten_phim"] ??
                                                      "Không có tên",
                                                  genre: movie["theloai"],
                                                  ageLimit:
                                                      movie["gioi_han_tuoi"],
                                                  isSneakShow:
                                                      movie["is_sneak_show"] ??
                                                      false,
                                                  totalRating:
                                                      (movie["tong_diem_danh_gia"] ??
                                                              0)
                                                          .toDouble(),
                                                  reviews:
                                                      movie["tong_so_danh_gia"] ??
                                                      0,
                                                ),
                                              );
                                            },
                                          )
                                      : const CustomLoading(
                                        width: 88,
                                        height: 88,
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// Phim sắp ra mắt
                      Container(
                        height: 360,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        child: Column(
                          children: [
                            CustomSectionHeader(
                              title: "Phim sắp ra mắt",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteNames.upcomingPage,
                                );
                              },
                            ),
                            Expanded(
                              child: Consumer<MovieProvider>(
                                builder: (context, value, child) {
                                  if (value.error2 != null) {
                                    return Center(
                                      child: Text(value.error2 ?? ""),
                                    );
                                  }
                                  return value.isLoading2 == false
                                      ? value.moviesSapRaMat.isEmpty
                                          ? const Text("Chưa có phim")
                                          : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                value.moviesSapRaMat.length,
                                            itemBuilder: (context, index) {
                                              final movie =
                                                  value.moviesSapRaMat[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: CustomItemVertical(
                                                  idMovie:
                                                      movie["ma_phim"] ?? 0,
                                                  imageUrl:
                                                      movie["anh_poster"] ?? "",
                                                  title:
                                                      movie["ten_phim"] ??
                                                      "Không có tên",
                                                  genre: movie["theloai"],
                                                  ageLimit:
                                                      movie["gioi_han_tuoi"],
                                                  isSneakShow:
                                                      movie["is_sneak_show"] ??
                                                      false,
                                                  totalRating:
                                                      (movie["tong_diem_danh_gia"] ??
                                                              0)
                                                          .toDouble(),
                                                  reviews:
                                                      movie["tong_so_danh_gia"] ??
                                                      0,
                                                ),
                                              );
                                            },
                                          )
                                      : const CustomLoading(
                                        width: 88,
                                        height: 88,
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

          /// Nếu có chữ cái đầu tiên khi nhập search
          if (showSearchResult)
            Container(
              color: Colors.white,
              child: Column(
                children: [
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
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          "Actors",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// Actors horizontal list
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: actors.length,
                            itemBuilder: (context, index) {
                              final actor = actors[index];
                              return _actorItem(
                                actor["name"],
                                actor["imageUrl"],
                              );
                            },
                            separatorBuilder:
                                (context, index) => const SizedBox(width: 16),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Movie Related",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "See All",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _movieItem(
                          "Spider-Man No Way Home",
                          "2021",
                          "148 Minutes",
                          "PG-13",
                        ),
                        _movieItem("Riverdale", "2021", "148 Minutes", "PG-13"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actorItem(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _movieItem(String title, String year, String duration, String rating) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(width: 50, color: Colors.grey),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          "$year • $duration • $rating",
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
