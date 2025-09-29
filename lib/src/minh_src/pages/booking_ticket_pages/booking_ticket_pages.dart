import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';

import 'package:tmt_project/src/minh_src/pages/takeSeat/take_seat_pages.dart';
import 'package:tmt_project/src/minh_src/pages/booking_ticket_pages/bookingProvider.dart';
import 'package:tmt_project/src/minh_src/pages/takeSeat/take_seat_pages.dart';

class BookingTicketPages extends StatefulWidget {
  final int movieId; // ma_phim
  final String movieTitle; // hiển thị AppBar
  final String poster; // hiển thị poster
  const BookingTicketPages({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.poster,
  });

  @override
  State<BookingTicketPages> createState() => _BookingTicketPagesState();
}

class _BookingTicketPagesState extends State<BookingTicketPages> {
  int _selectedCumRapIndex = 0;
  int _selectedDateIndex = 0;

  late final List<DateTime> _dates;
  final DateFormat _displayFmt = DateFormat('dd MMM\nEEE');
  final DateFormat _apiFmt = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dates = List.generate(
      5,
      (i) => DateTime(now.year, now.month, now.day).add(Duration(days: i)),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cumRap = context.read<CumRapProvider>();
      if (cumRap.cumRapMap == null || cumRap.cumRapMap!.isEmpty) {
        await cumRap.fetchCumRap();
      }
      await _fetchShowtimesIfReady();
    });
  }

  int? _currentCumRapId(BuildContext context) {
    final map = context.read<CumRapProvider>().cumRapMap;
    if (map == null || map.isEmpty) return null;
    final keys = map.keys.toList(growable: false);
    if (_selectedCumRapIndex < 0 || _selectedCumRapIndex >= keys.length)
      return null;
    return keys[_selectedCumRapIndex];
  }

  Future<void> _fetchShowtimesIfReady() async {
    final map = context.read<CumRapProvider>().cumRapMap;
    if (map == null || map.isEmpty) return;

    final maCumRap = _currentCumRapId(context);
    if (maCumRap == null) return;

    final ngayApi = _apiFmt.format(_dates[_selectedDateIndex]);
    await context.read<SuatChieuProvider>().fetchSuatChieu(
      maPhim: widget.movieId,
      maCumRap: maCumRap,
      ngay: ngayApi,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cumRapState = context.watch<CumRapProvider>();
    final suatChieuState = context.watch<SuatChieuProvider>();

    final cumRapMap = cumRapState.cumRapMap ?? {};
    final cumRapNames = cumRapMap.values.toList(growable: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.movieTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'TP.HCM >',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle("Cụm rạp"),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: _buildCumRapChips(
                isLoading:
                    cumRapState.isLoadingCumRap == true && cumRapMap.isEmpty,
                error: cumRapState.errorCumRap,
                items: cumRapNames,
                selectedIndex: _selectedCumRapIndex,
                onSelected: (i) async {
                  setState(() => _selectedCumRapIndex = i);
                  await _fetchShowtimesIfReady();
                },
              ),
            ),
            const SizedBox(height: 12),
            _SectionTitle("Ngày chiếu"),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final isSelected = i == _selectedDateIndex;
                  return GestureDetector(
                    onTap: () async {
                      setState(() => _selectedDateIndex = i);
                      await _fetchShowtimesIfReady();
                    },
                    child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            isSelected
                                ? const Color(0xFFEF4444)
                                : Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                      ),
                      child: Text(
                        _displayFmt.format(_dates[i]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _SectionTitle("Suất chiếu"),
            const SizedBox(height: 8),
            Expanded(child: _buildShowtimeList(context, suatChieuState)),
          ],
        ),
      ),
    );
  }

  Widget _buildCumRapChips({
    required bool isLoading,
    required String? error,
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    if (isLoading) {
      return const Center(child: CustomLoading(width: 88, height: 88));
    }

    if (error != null && items.isEmpty) {
      return Center(
        child: Text(error, style: const TextStyle(color: Colors.red)),
      );
    }

    if (items.isEmpty) {
      return const Center(child: Text("Không có cụm rạp khả dụng"));
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (listCtx, i) {
        final isSelected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  isSelected
                      ? const Color(0xFFEF4444)
                      : Theme.of(listCtx).colorScheme.primaryContainer,
            ),
            child: Text(
              items[i],
              style: TextStyle(
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(listCtx).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShowtimeList(BuildContext context, SuatChieuProvider state) {
    if (state.isLoading) {
      return const Center(child: CustomLoading(width: 88, height: 88));
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.rapPhimList.isEmpty) {
      return const Center(child: Text("Không có suất chiếu cho lựa chọn này."));
    }

    return ListView.builder(
      itemCount: state.rapPhimList.length,
      itemBuilder: (_, i) {
        final rap = state.rapPhimList[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rap.tenRap ?? "Rạp #${rap.maRap}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rap.diaChi ?? "",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Tìm đường',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...(rap.phongChieu ?? []).map((pc) {
                final loai = pc.loaiSuat?.tenLoaiSuat ?? "Khác";
                final suat = pc.suatChieu ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loai,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          suat.map((s) {
                            final start = _parseAndFormatTime(s.thoiGianChieu);
                            final end = _parseAndFormatTime(s.thoiGianKetThuc);

                            final cumRapList =
                                context.read<CumRapProvider>().cumRapList ?? [];
                            final selectedCumRap =
                                cumRapList[_selectedCumRapIndex];
                            final maHeThong = selectedCumRap.maHeThong ?? 0;

                            return _ShowtimeChip(
                              label: "$start ~ $end",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TakeSeatPages(
                                          poster: widget.poster,
                                          maPhong: rap.maRap ?? 0,
                                          maSuatChieu: s.maSuatChieu ?? 0,
                                          theaterName: rap.tenRap ?? '',
                                          receiveDate: _displayFmt.format(
                                            _dates[_selectedDateIndex],
                                          ),
                                          movieTitle: widget.movieTitle,
                                          showTime: "$start ~ $end",
                                          maHeThong: maHeThong,
                                        ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  String _parseAndFormatTime(DateTime? dt) {
    if (dt == null) return "--:--";
    try {
      return DateFormat('HH:mm').format(dt.toLocal());
    } catch (_) {
      return "--:--";
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ShowtimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ShowtimeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF666666), Color(0xFFB3B3B3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
