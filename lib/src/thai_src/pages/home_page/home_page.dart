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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code này sẽ chạy sau khi build widget xong
      context.read<MovieProvider>().layPhimDangChieu();
      context.read<MovieProvider>().layPhimSapRaMat();
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
              Navigator.pushNamed(context, AppRouteNames.filterPage);
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

                  /// Phim sắp ra mắt
                  Container(
                    height: 350,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
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
                        // Danh sách phim đang chiếu
                        Expanded(
                          child: Consumer<MovieProvider>(
                            builder: (
                              BuildContext context,
                              value,
                              Widget? child,
                            ) {
                              if (value.error != null) {
                                return Center(child: Text(value.error ?? ""));
                              }
                              return value.isLoading == false
                                  ? value.moviesDangChieu.isEmpty
                                      ? Text("Chưa có phim")
                                      : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: value.moviesDangChieu.length,
                                        itemBuilder: (context, index) {
                                          final movie =
                                              value.moviesDangChieu[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: CustomItemVertical(
                                              idMovie: movie["ma_phim"],
                                              imageUrl: movie["anh_poster"],
                                              title: movie["ten_phim"],
                                              genre: movie["theloai"],

                                              ageLimit: movie["gioi_han_tuoi"],
                                              isSneakShow:
                                                  movie["is_sneak_show"] ??
                                                  false,
                                              totalRating:
                                                  (movie["tong_diem_danh_gia"]),
                                              reviews:
                                                  movie["tong_so_danh_gia"],
                                            ),
                                          );
                                        },
                                      )
                                  : CustomLoading(width: 88, height: 88);
                            },
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    height: 350,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
                        /// Phim sắp ra mắt
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
                        Expanded(
                          child: Consumer<MovieProvider>(
                            builder: (
                              BuildContext context,
                              value,
                              Widget? child,
                            ) {
                              if (value.error2 != null) {
                                return Center(child: Text(value.error2 ?? ""));
                              }
                              return value.isLoading2 == false
                                  ? value.moviesSapRaMat.isEmpty
                                      ? Text("Chưa có phim")
                                      : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: value.moviesSapRaMat.length,
                                        itemBuilder: (context, index) {
                                          final movie =
                                              value.moviesSapRaMat[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: CustomItemVertical(
                                              idMovie: movie["ma_phim"],
                                              imageUrl: movie["anh_poster"],
                                              title: movie["ten_phim"],
                                              genre: movie["theloai"],

                                              ageLimit: movie["gioi_han_tuoi"],
                                              isSneakShow:
                                                  movie["is_sneak_show"] ??
                                                  false,
                                              totalRating:
                                                  (movie["tong_diem_danh_gia"]),

                                              reviews:
                                                  movie["tong_so_danh_gia"],
                                            ),
                                          );
                                        },
                                      )
                                  : CustomLoading(width: 88, height: 88);
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
