import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/minh/customCarousel.dart';
import 'package:tmt_project/core/widgets/minh/custom_item_vertical.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page_provider.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_search_widget.dart';
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
      context.read<MovieProvider>().layPhimDangHot();
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
              // Thanh tìm kiếm - cho riêng trang home
              HomeSearchWidget(
                controller: _searchController,
                onFilterTap: () {
                  Navigator.pushNamed(context, AppRouteNames.filterPage);
                },
                onChanged: () {
                  Navigator.pushNamed(context, AppRouteNames.searchPage);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomSectionHeader(title: "Phim nổi bật", isTap: false),
                      Consumer<MovieProvider>(
                        builder: (context, provider, child) {
                          if (provider.error3 != null) {
                            return Center(child: Text(provider.error3!));
                          }
                          if (provider.isLoading3 == true) {
                            return const CustomLoading(width: 88, height: 88);
                          }
                          // map backend -> Movie
                          final movies =
                              provider.moviesDangHot.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final json = entry.value;
                                return Movie.fromJson(json, rank: index + 1);
                              }).toList();

                          return MovieCarousel(movies: movies);
                        },
                      ),
                      SizedBox(height: 16),

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
        ],
      ),
    );
  }
}
