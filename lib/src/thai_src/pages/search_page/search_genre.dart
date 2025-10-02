import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_tabBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_item_horizontal.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/filter_page/filter_provider.dart';
import 'package:tmt_project/src/thai_src/widget/empty.dart';

class SearchGenre extends StatefulWidget {
  const SearchGenre({super.key});

  @override
  State<SearchGenre> createState() => _SearchGenreState();
}

class _SearchGenreState extends State<SearchGenre> {
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
        return Colors.orange; // Đang chiếu
      case 2:
        return Colors.green; // Sắp chiếu
      case 3:
        return Colors.grey; // Ngưng chiếu
      default:
        return Colors.blueGrey;
    }
  }

  int initialTabIndex = 0; // mặc định tab đầu tiên

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final provider = Provider.of<FilterProvider>(context, listen: false);
      provider.layTheLoaiPhim();
      if (args != null) {
        if (args is List) {
          provider.layTheoTheLoai(args[0]);
          initialTabIndex = args[1];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Thể loại",
        listIcon: [],
        showLeading: true,
      ),
      body: Consumer<FilterProvider>(
        builder: (context, filterProvider, child) {
          if (filterProvider.isLoading) {
            return const Center(child: CustomLoading(width: 88, height: 88));
          }
          if (filterProvider.error != null) {
            return Center(child: Text(filterProvider.error!));
          }
          if (filterProvider.categories.isEmpty) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          final ids = filterProvider.categories.keys.toList();
          final names = filterProvider.categories.values.toList();

          return Column(
            children: [
              Expanded(
                child: CustomTabBar(
                  tabs: List.generate(
                    names.length,
                    (index) => Text(names[index]),
                  ),
                  tabViews: List.generate(
                    ids.length,
                    (index) => _buildCustomListView(ids[index]),
                  ),
                  onTabChanged: (index) {
                    final provider = Provider.of<FilterProvider>(
                      context,
                      listen: false,
                    );
                    provider.layTheoTheLoai(ids[index]);
                  },
                  initialIndex: initialTabIndex,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  unselectedColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomListView(int categoryId) {
    return Consumer<FilterProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading2 &&
            (provider.moviesByCategory[categoryId] == null)) {
          return const Center(child: CustomLoading(width: 88, height: 88));
        }
        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }
        final movies = provider.moviesByCategory[categoryId] ?? [];
        if (movies.isEmpty) {
          return Empty();
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    AppRouteNames.detailPages,
                    arguments: movie["ma_phim"],
                  ), // e sửa lại chỗ này
              child: CustomItemHorizontal(
                imageUrl: movie["anh_poster"] ?? "đang cập nhập",
                title: movie["ten_phim"] ?? "chưa cập nhập",
                year: DateTime.parse(movie["ngay_phat_hanh"]).year.toString(),
                stateMovies: trangThaiToPhim(movie["trang_thai_toan_cuc"]),
                stateColor: trangThaiToColor(movie["trang_thai_toan_cuc"]),
                duration: movie["thoi_luong_phut"] ?? 0,
                ageRating: movie["gioi_han_tuoi"]["ky_hieu"].toString(),
                genres:
                    movie["theloai"] != null
                        ? List<String>.from(
                          movie["theloai"].map(
                            (tl) => tl["theLoai"]["ten_the_loai"].toString(),
                          ),
                        )
                        : [],
                rating:
                    double.tryParse(movie["danh_gia"]?.toString() ?? "0") ??
                    0.0,
              ),
            );
          },
        );
      },
    );
  }
}
