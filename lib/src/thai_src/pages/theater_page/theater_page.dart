import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/new_provider.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page/theater_provider.dart';
import 'package:tmt_project/src/thai_src/widget/custom_animation.dart';
import 'package:tmt_project/src/thai_src/widget/custom_card_theater.dart';
import 'package:tmt_project/src/thai_src/widget/custom_section.dart';
import 'package:tmt_project/src/thai_src/widget/custom_selector.dart';

class TheaterPage extends StatefulWidget {
  const TheaterPage({super.key});

  @override
  State<TheaterPage> createState() => _TheaterPageState();
}

class _TheaterPageState extends State<TheaterPage> {
  /// chọn rạp phim
  int selectedBrand = 0;
  // Giá trị rạp hiện tại
  String selectedCinema = "CGV";

  /// lấy chuỗi trong địa chỉ
  String getDistrict(String address) {
    final regex = RegExp(r"(Quận\s[^,]+)");
    final match = regex.firstMatch(address);
    if (match != null) {
      return match.group(0) ?? "";
    }
    return "Chưa rõ quận";
  }

  final Map<int, String> brandLogos = {
    1: "https://gigamall.vn/data/2019/05/06/11365490_logo-cgv-500x500.jpg", // CGV
    2: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRB1fjf7chcOg_lbsP7McnmgLfMQNVOucA-IA&s", // Lotte
    3: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtBO_eehVOKwYQEuKUT9jc8Q0rD9ttuJ0dEA&s", // Galaxy
  };

  final List<Map<String, String>> theaterList = [
    {
      "name": "CGV Vincom Đồng Khởi",
      "address": "72 Lê Thánh Tôn, Quận 1, TP.HCM",
      "ward": "Quận Tân Bình . 1.1km",
      "logoUrl":
          "https://tenten.vn/tin-tuc/wp-content/uploads/2022/08/Lam-dep-code.jpg",
    },
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code này sẽ chạy sau khi build widget xong
      context.read<TheaterProvider>().layCacCumRap();
      context.read<TheaterProvider>().layTatCaRapPhim(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Chọn rạp xem phim",
        listIcon: [],
        showLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          // Banner tin tức
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Consumer<NewsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.newsList.isEmpty) {
                    return const Center(
                      child: CustomLoading(width: 88, height: 88),
                    );
                  }
                  if (provider.error != null) {
                    return Center(child: Text(provider.error!));
                  }
                  if (provider.newsList.isEmpty) {
                    return const Center(child: Text("Không có dữ liệu"));
                  }
                  return CustomAnimation(
                    newsList: provider.newsList.take(5).toList(),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          // Section chọn rạp
          SliverToBoxAdapter(
            child: CustomSectionHeader(title: "Rạp chiếu phim", isTap: false),
          ),
          // Brand selector
          SliverToBoxAdapter(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Consumer<TheaterProvider>(
                builder: (context, provider, child) {
                  if (provider.error != null) {
                    return Center(child: Text(provider.error!));
                  }
                  if (provider.isLoading == true) {
                    return const CustomLoading(width: 88, height: 88);
                  }
                  return provider.isLoading == false
                      ? provider.theaterMovies.isEmpty
                          ? const Text("Chưa có Rạp phim nào!!")
                          : SizedBox(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // 👉 Thêm "Rạp gần bạn" ở cuối
                                GestureDetector(
                                  onTap: () async {
                                    if (provider.isLoadingNear)
                                      return; // đang chạy thì bỏ

                                    setState(() {
                                      selectedBrand = -1;
                                      selectedCinema = "Rạp gần bạn";
                                    });

                                    final location =
                                        await context
                                            .read<TheaterProvider>()
                                            .getCurrentLocation();
                                    if (location[0] != null &&
                                        location[1] != null) {
                                      provider.viDo = location[0];
                                      provider.kinhDo = location[1];
                                      await provider.layRapGan();
                                    }
                                  },
                                  child: CustomSelector(
                                    names: "Gần bạn",
                                    images:
                                        "https://cdn-icons-png.flaticon.com/512/854/854894.png", // icon location
                                    isSelected: selectedBrand == -1,
                                  ),
                                ),
                                // Các hệ thống rạp từ provider
                                ...provider.theaterMovies.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final theater = entry.value;
                                  final theaterName = theater["ten_he_thong"];
                                  final theaterId = theater["ma_he_thong"];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedBrand = index;
                                        selectedCinema = theaterName ?? "";
                                      });
                                      final theaterId = theater["ma_he_thong"];
                                      if (theaterId != null) {
                                        context
                                            .read<TheaterProvider>()
                                            .layTatCaRapPhim(theaterId);
                                      } else {
                                        debugPrint(
                                          "Không tìm thấy id trong rap phim",
                                        );
                                      }
                                    },
                                    child: CustomSelector(
                                      names: theaterName,
                                      images: brandLogos[theaterId] ?? "",
                                      isSelected: selectedBrand == index,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )
                      : const CustomLoading(width: 88, height: 88);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Danh sách rạp phim
          // Danh sách rạp phim (theo brand hoặc gần bạn)
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Column(
                children: [
                  CustomSectionHeader(
                    title:
                        selectedBrand == -1
                            ? "Rạp chiếu gần bạn"
                            : "Rạp phim: $selectedCinema",
                    isTap: false,
                  ),
                  Consumer<TheaterProvider>(
                    builder: (context, provider, child) {
                      // Nếu chọn "Gần bạn"
                      if (selectedBrand == -1) {
                        if (provider.errorNear != null) {
                          return Column(
                            children: [
                              Text(provider.errorNear!),
                              const SizedBox(height: 8),
                              if (provider.errorNear!.contains("Cài đặt"))
                                OutlinedButton(
                                  onPressed: () {
                                    Geolocator.openAppSettings();
                                  },
                                  child: const Text("Mở Cài đặt"),
                                )
                              else
                                OutlinedButton(
                                  onPressed: () async {
                                    final location =
                                        await context
                                            .read<TheaterProvider>()
                                            .getCurrentLocation();
                                    if (location[0] != null &&
                                        location[1] != null) {
                                      provider.viDo = location[0];
                                      provider.kinhDo = location[1];
                                      provider.layRapGan();
                                    }
                                  },
                                  child: const Text("Cấp quyền"),
                                ),
                            ],
                          );
                        }

                        if (provider.isLoadingNear == true) {
                          return const CustomLoading(width: 88, height: 88);
                        }

                        if (provider.theaterNear.isEmpty) {
                          return const Text("Không có rạp phim nào!!");
                        }

                        return Column(
                          children:
                              provider.theaterNear.map((theater) {
                                final theaterId = theater["ma_he_thong"];
                                return CustomCardTheater(
                                  title: theater["ten_rap"] ?? "",
                                  address: theater["dia_chi"] ?? "",
                                  ward: getDistrict(theater["dia_chi"] ?? ""),
                                  image: brandLogos[theaterId] ?? "",
                                  onTap: () {},
                                  onDirectionTap: () {
                                    // chỉ đường
                                    context
                                        .read<TheaterProvider>()
                                        .moBanDoChiDuong(
                                          context,
                                          theater["vi_do"],
                                          theater["kinh_do"],
                                        );
                                  },
                                );
                              }).toList(),
                        );
                      }

                      // Nếu chọn thương hiệu cụ thể
                      if (provider.errorTakeAll != null) {
                        return Center(child: Text(provider.errorTakeAll!));
                      }
                      if (provider.isLoadingTakeAll == true) {
                        return const CustomLoading(width: 88, height: 88);
                      }
                      if (provider.theaterTakeAll.isEmpty) {
                        return const Text("Không có rạp phim nào!!");
                      }

                      return Column(
                        children:
                            provider.theaterTakeAll.map((theater) {
                              final theaterId = theater["ma_he_thong"];
                              return CustomCardTheater(
                                title: theater["ten_rap"] ?? "",
                                address: theater["dia_chi"] ?? "",
                                ward: getDistrict(theater["dia_chi"] ?? ""),
                                image: brandLogos[theaterId] ?? "",
                                onTap: () {},
                                onDirectionTap: () {
                                  // chỉ đường

                                  context
                                      .read<TheaterProvider>()
                                      .moBanDoChiDuong(
                                        context,
                                        theater["vi_do"],
                                        theater["kinh_do"],
                                      );
                                },
                              );
                            }).toList(),
                      );
                    },
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
