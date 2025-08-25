import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/src/thai_src/widget/custom_card_theater.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';
import 'package:tmt_project/src/thai_src/widget/custom_section.dart';
import 'package:tmt_project/src/thai_src/widget/custom_selector.dart';

class TheaterPage extends StatefulWidget {
  const TheaterPage({super.key});

  @override
  State<TheaterPage> createState() => _TheaterPageState();
}

class _TheaterPageState extends State<TheaterPage> {
  final TextEditingController _searchController = TextEditingController();

  /// chọn rạp phim
  int selectedBrand = 1;
  // Giá trị rạp hiện tại
  String selectedCinema = "CGV";

  /// call API trả về 2 list này
  final List<int> brand = [1, 2, 3];

  final List<String> brandLogos = [
    "https://picsum.photos/id/1027/800/500",
    "https://picsum.photos/id/1027/800/500",
    "https://picsum.photos/id/1027/800/500",
  ];
  final List<Map<String, String>> theaterList = [
    {
      "name": "CGV Vincom Đồng Khởi",
      "address": "72 Lê Thánh Tôn, Quận 1, TP.HCM",
      "ward": "Quận Tân Bình . 1.1km",
      "logoUrl": "https://picsum.photos/id/1005/800/500",
    },
    {
      "name": "CGV Vincom Đồng Khởi",
      "address": "72 Lê Thánh Tôn, Quận 1, TP.HCM",
      "ward": "Quận Tân Bình . 1.1km",
      "logoUrl": "https://picsum.photos/id/1005/800/500",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Chọn rạp xem phim",
        listIcon: [],
        showLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Row(
              children: [
                // Thanh tìm kiếm
                Expanded(
                  child: SearchBarWidget(
                    controller: _searchController,
                    hintText: "Tìm rạp phim",
                    showFilter: false,
                    onChanged: (value) {
                      // xử lý search real-time
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    "TP.HCM",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chọn rạp phim
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          brand.map((brands) {
                            return CustomSelector(
                              names: "CGV",
                              images: "https://picsum.photos/id/1027/800/500",
                              isSelected: selectedBrand == brands,
                              onTap: () {
                                setState(() {
                                  selectedBrand = brands;
                                  selectedCinema = "CGV";
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24)),
                // Rạp phim
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
                        CustomSectionHeader(
                          title: "Rạp phim: $selectedCinema",
                          isTap: false,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: theaterList.length,
                            itemBuilder: (context, index) {
                              final theater = theaterList[index];
                              return CustomCardTheater(
                                title: theater["name"] ?? "",
                                address: theater["address"] ?? "",
                                ward: theater["ward"] ?? "",
                                image: theater["logoUrl"] ?? "",
                                onTap: () {},
                                onDirectionTap: () {},
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24)),
                // Rạp chiếu gần bạn
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Column(
                      children: [
                        CustomSectionHeader(
                          title: "Rạp chiếu gần bạn",
                          isTap: false,
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                              theaterList
                                  .map(
                                    (listTheater) => CustomCardTheater(
                                      title: listTheater["name"] ?? "",
                                      address: listTheater["address"] ?? "",
                                      ward: listTheater["ward"] ?? "",
                                      image: listTheater["logoUrl"] ?? "",
                                      onTap: () {},
                                      onDirectionTap: () {},
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
