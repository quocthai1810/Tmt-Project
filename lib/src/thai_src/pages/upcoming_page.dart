import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/minh/custom_item_vertical.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/src/thai_src/pages/home_page/home_page_provider.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';

class UpcomingMoviesPage extends StatefulWidget {
  const UpcomingMoviesPage({super.key});

  @override
  State<UpcomingMoviesPage> createState() => _UpcomingMoviesPageState();
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> movies = [];
  String showSearchResult = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code này sẽ chạy sau khi build widget xong
      context.read<MovieProvider>().layPhimSapRaMat();
    });
    _searchController.addListener(() {
      setState(() {
        showSearchResult = _searchController.text.trim().toLowerCase();
      });
    });
  }

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
            child: Consumer<MovieProvider>(
              builder: (context, value, child) {
                if (value.error2 != null) {
                  return Center(child: Text(value.error2 ?? ""));
                }

                if (value.isLoading2!) {
                  return const CustomLoading(width: 88, height: 88);
                }
                // Danh sách phim gốc
                final movies = value.moviesSapRaMat;
                // Nếu không có searchResult => hiển thị toàn bộ phim
                List filteredMovies =
                    showSearchResult.isEmpty
                        ? movies
                        : movies.where((movie) {
                          final title =
                              (movie["ten_phim"] ?? "")
                                  .toString()
                                  .toLowerCase();
                          return title.contains(showSearchResult);
                        }).toList();
                if (filteredMovies.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/img/searchResult.png"),
                      SizedBox(height: 24),
                      Text(
                        "Rất tiếc, chúng tôi không tìm thấy phim :(",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tìm phim theo Loại, Thể loại, Năm, v.v.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.67,
                  ),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return CustomItemVertical(
                      idMovie: movie["ma_phim"] ?? 0,
                      imageUrl: movie["anh_poster"] ?? "",
                      title: movie["ten_phim"] ?? "Không có tên",
                      genre: movie["theloai"],
                      ageLimit: movie["gioi_han_tuoi"],
                      isSneakShow: movie["is_sneak_show"] ?? false,
                      totalRating:
                          (movie["tong_diem_danh_gia"] ?? 0).toDouble(),
                      reviews: movie["tong_so_danh_gia"] ?? 0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
