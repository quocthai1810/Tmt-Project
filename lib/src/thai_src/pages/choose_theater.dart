import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/new_provider.dart';
import 'package:tmt_project/src/thai_src/pages/theater_page/theater_provider.dart';
import 'package:tmt_project/src/thai_src/widget/custom_animation.dart';
import 'package:tmt_project/src/thai_src/widget/custom_choose_theater.dart';
import 'package:tmt_project/src/thai_src/widget/custom_section.dart';

class ChooseTheater extends StatefulWidget {
  const ChooseTheater({super.key});

  @override
  State<ChooseTheater> createState() => _ChooseTheaterState();
}

class _ChooseTheaterState extends State<ChooseTheater> {
  int selectedDayIndex = 0;
  final int totalDays = 14;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code này sẽ chạy sau khi build widget xong
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final theaterId = args["ma_rap"] as int;
      context.read<TheaterProvider>().layXuatChieuTheoRap(
        theaterId,
        DateTime.now(),
      );
    });
  }

  List<DateTime> getDays() {
    final now = DateTime.now();
    return List.generate(totalDays, (i) => now.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final days = getDays();
    final theaterName = args["ten_rap"] as String;

    return Scaffold(
      appBar: CustomAppbar(
        textTitle: theaterName,
        listIcon: [],
        showLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          /// Banner tin tức
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
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          /// Chọn ngày
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isToday = DateUtils.isSameDay(day, DateTime.now());
                  final isSelected = selectedDayIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                      final args =
                          ModalRoute.of(context)!.settings.arguments as Map;
                      final theaterId = args["ma_rap"] as int;
                      // Gọi API load phim theo ngày
                      context.read<TheaterProvider>().layXuatChieuTheoRap(
                        theaterId,
                        day,
                      );
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isToday ? "H.nay" : DateFormat.E("vi").format(day),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat("dd").format(day),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : (isToday
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// Danh sách phim
          const SliverToBoxAdapter(
            child: CustomSectionHeader(title: "Danh sách phim", isTap: false),
          ),

          SliverToBoxAdapter(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Consumer<TheaterProvider>(
                builder: (context, provider, child) {
                  if (provider.errorShow != null) {
                    return Center(child: Text(provider.errorShow!));
                  }
                  if (provider.isLoadingShow == true) {
                    return const CustomLoading(width: 88, height: 88);
                  }
                  return provider.isLoadingShow == false
                      ? provider.theaterShow.isEmpty
                          ? const Text("Chưa có xuất chiếu nào!!")
                          : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.theaterShow.length,
                            itemBuilder: (context, index) {
                              final theaterShow = provider.theaterShow[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CustomChooseTheater(
                                  onShowTimeTap: (showTime) {
                                    final selectedDay = days[selectedDayIndex];
                                    final receiveDate = DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(selectedDay);

                                    final String movieTitle =
                                        theaterShow["ten_phim"] ??
                                        "Phim chưa rõ tên";
                                    final String? rawShowTime =
                                        showTime["gio_chieu"];
                                    final String showTimeValue =
                                        rawShowTime ?? "00:00";

                                    final int maSuatChieu =
                                        showTime["ma_suat_chieu"] ?? 0;
                                    final int maPhong =
                                        showTime["ma_phong"] ?? 0;

                                    if (rawShowTime == null) {
                                      debugPrint(
                                        "⚠️ Cảnh báo: suất chiếu không có giờ chiếu rõ ràng!",
                                      );
                                    }

                                    Navigator.pushNamed(
                                      context,
                                      AppRouteNames.takeSeatPages,
                                      arguments: SeatPageArguments(
                                        movieTitle: movieTitle,
                                        theaterName: theaterName,
                                        receiveDate: receiveDate,
                                        showTime: showTimeValue,
                                        maPhong: maPhong,
                                        maSuatChieu: maSuatChieu,
                                        maHeThong:
                                            theaterShow["ma_he_thong"] ?? 0,
                                      ),
                                    );
                                  },

                                  title: theaterShow["ten_phim"],
                                  imageUrl: theaterShow["anh_poster"],
                                  genre: theaterShow["theloai"],
                                  ageLimit:
                                      theaterShow["gioi_han_tuoi"]["ky_hieu"],
                                  showTimes: theaterShow["suat_chieu"],
                                ),
                              );
                            },
                          )
                      : const CustomLoading(width: 88, height: 88);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
