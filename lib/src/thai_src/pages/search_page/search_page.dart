import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/tin/custom_item_horizontal.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';
import 'package:tmt_project/src/thai_src/widget/empty.dart';
import 'search_provider.dart'; // import provider bạn đã viết

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce; // ✅ thêm biến debounce

  String trangThaiToPhim(int? state) {
    switch (state) {
      case 1:
        return "Đang chiếu";
      case 2:
        return "Sắp chiếu";
      case 3:
        return "Ngưng chiếu";
      default:
        return "Chưa có";
    }
  }

  Color trangThaiToColor(int? state) {
    switch (state) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      // Hủy timer cũ nếu còn
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // Set lại timer mới
      _debounce = Timer(const Duration(seconds: 1), () {
        context.read<SearchProvider>().updateSearch(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // hủy khi dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Thanh search
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Row(
              children: [
                Expanded(
                  child: SearchBarWidget(
                    controller: _searchController,
                    showFilter: false,
                    onChanged: () {
                      // context.read<SearchProvider>().updateSearch(value);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SearchProvider>().searchMovies = [];
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),

          /// Kết quả search
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CustomLoading(width: 88, height: 88),
                  );
                }

                if (provider.error != null) {
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

                final results = provider.searchMovies;
                if (results.isEmpty && _searchController.text.isNotEmpty) {
                  return Empty();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final movie = results[index];
                    return GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            AppRouteNames.detailMovie,
                            arguments: movie["ma_phim"],
                          ),
                      child: CustomItemHorizontal(
                        imageUrl: movie["anh_poster"] ?? "đang cập nhập",
                        title: movie["ten_phim"] ?? "chưa cập nhập",
                        year:
                            DateTime.parse(
                              movie["ngay_phat_hanh"],
                            ).year.toString(),
                        stateMovies: trangThaiToPhim(
                          movie["trang_thai_toan_cuc"],
                        ),
                        stateColor: trangThaiToColor(
                          movie["trang_thai_toan_cuc"],
                        ),
                        duration: movie["thoi_luong_phut"] ?? 0,
                        ageRating: movie["gioi_han_tuoi"]["ky_hieu"].toString(),
                        genres:
                            movie["theloai"] != null
                                ? List<String>.from(
                                  movie["theloai"].map(
                                    (tl) =>
                                        tl["theLoai"]["ten_the_loai"]
                                            .toString(),
                                  ),
                                )
                                : [],
                        rating:
                            double.tryParse(
                              movie["danh_gia"]?.toString() ?? "0",
                            ) ??
                            0.0,
                      ),
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
