import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomChooseTheater extends StatelessWidget {
  final String title;
  final String imageUrl;
  final List<dynamic> genre;
  final String ageLimit;
  final List<dynamic> showTimes;

  const CustomChooseTheater({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.ageLimit,
    required this.showTimes,
  });

  String formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime).add(const Duration(hours: 7));
    return DateFormat.Hm().format(dateTime); // HH:mm
  }

  @override
  Widget build(BuildContext context) {
    // Nhóm suất chiếu theo loại (2D, 3D, 4D...)
    final Map<String, List<dynamic>> groupedShows = {};
    for (var show in showTimes) {
      final type = show["phong"]["loai_suat"]["ten_loai_suat"];
      groupedShows.putIfAbsent(type, () => []);
      groupedShows[type]!.add(show);
    }
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AgeLimit + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ageLimit,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Genre + Duration
            Row(
              children: List.generate(genre.length, (index) {
                final text = genre[index]["theLoai"]["ten_the_loai"] as String;
                return Row(
                  children: [
                    Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                    if (index != genre.length - 1)
                      const Text(
                        " | ",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w500$imageUrl",
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                /// Danh sách suất chiếu (theo loại)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        groupedShows.entries.map((entry) {
                          final type = entry.key; // ví dụ: "2D"
                          final shows = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// In ra loại suất chiếu 1 lần duy nhất
                                Text(
                                  "$type Phụ đề",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                /// Các giờ chiếu của loại này
                                Column(
                                  children: List.generate(
                                    (shows.length / 2).ceil(),
                                    (rowIndex) {
                                      final start = rowIndex * 2;
                                      final end =
                                          (start + 2 <= shows.length)
                                              ? start + 2
                                              : shows.length;
                                      final rowShows = shows.sublist(
                                        start,
                                        end,
                                      );

                                      return Row(
                                        children:
                                            rowShows.map((show) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8,
                                                  bottom: 8,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        formatTime(
                                                          show["thoi_gian_chieu"],
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        "~ ${formatTime(show["thoi_gian_ket_thuc"])}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
