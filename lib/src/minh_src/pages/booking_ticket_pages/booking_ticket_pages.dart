import 'package:flutter/material.dart';
import 'package:tmt_project/src/minh_src/pages/takeCombo/take_combo_pages.dart';
import 'package:tmt_project/src/minh_src/pages/booking_ticket_pages/bookingProvider.dart';
import 'package:tmt_project/src/minh_src/pages/chooseSeat/choose_seat_page.dart';
import 'package:tmt_project/src/minh_src/pages/takeSeat/take_seat_pages.dart';

class BookingTicketPages extends StatefulWidget {
  final String movieTitle;
  const BookingTicketPages({super.key, required this.movieTitle});

  @override
  State<BookingTicketPages> createState() => _BookingTicketPagesState();
}

class _BookingTicketPagesState extends State<BookingTicketPages> {
  int selectedBrand = 0;
  int selectedDate = 0;

  final List<String> cinemaBrands = [
    'CGV',
    'Lotte',
    'Galaxy',
    'CineMax',
    'Mons',
    'Theme.',
  ];

  final List<String> dates = [
    '20 Nov\nWED',
    '21 Nov\nTHU',
    '22 Nov\nFRI',
    '23 Nov\nSAT',
    '24 Nov\nSUN',
  ];

  final Map<String, List<Map<String, dynamic>>> cinemasByBrand = {
    'CGV': [
      {
        'name': 'CGV Hoàng Văn Thụ',
        'distance': '1.1km',
        'address': 'Tầng 1 và 2, Gala, số 415, Hoàng Văn Thụ, Tân Bình',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['21:25 ~ 00:17', '18:30 ~ 20:20'],
            'seats': ['77/84', '105/200'],
          },
          {
            'type': '3D Thuyết Minh',
            'times': ['16:15 ~ 18:45'],
            'seats': ['60/84'],
          },
          {
            'type': '4D Phụ đề',
            'times': ['14:00 ~ 16:00'],
            'seats': ['50/84'],
          },
        ],
      },
      {
        'name': 'CGV Tân Phú',
        'distance': '3.2km',
        'address': 'Aeon Mall Tân Phú, Q. Tân Phú',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['19:00 ~ 21:00'],
            'seats': ['120/150'],
          },
          {
            'type': '3D Thuyết Minh',
            'times': ['16:45 ~ 18:45'],
            'seats': ['80/84'],
          },
        ],
      },
    ],
    'Lotte': [
      {
        'name': 'Lotte Gò Vấp',
        'distance': '2.5km',
        'address': 'Lotte Mart Gò Vấp, Q. Gò Vấp',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['15:30 ~ 17:30'],
            'seats': ['65/80'],
          },
        ],
      },
    ],
    'Galaxy': [
      {
        'name': 'Galaxy Nguyễn Du',
        'distance': '1.0km',
        'address': '116 Nguyễn Du, Q.1',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['18:00 ~ 20:00'],
            'seats': ['90/120'],
          },
        ],
      },
    ],
    'CineMax': [
      {
        'name': 'CineMax Phú Nhuận',
        'distance': '2.0km',
        'address': '123 Phan Đăng Lưu, Q. Phú Nhuận',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['14:00 ~ 16:00'],
            'seats': ['70/90'],
          },
        ],
      },
    ],
    'Mons': [
      {
        'name': 'Mons Cine Quận 10',
        'distance': '1.4km',
        'address': '70 Thành Thái, Q.10',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['20:00 ~ 22:00'],
            'seats': ['88/100'],
          },
        ],
      },
    ],
    'Theme.': [
      {
        'name': 'Theme Cinema Bình Thạnh',
        'distance': '2.8km',
        'address': '234 Xô Viết Nghệ Tĩnh, Q. Bình Thạnh',
        'schedules': [
          {
            'type': '2D Phụ đề',
            'times': ['17:30 ~ 19:30'],
            'seats': ['73/90'],
          },
        ],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final selectedCinemas = cinemasByBrand[cinemaBrands[selectedBrand]] ?? [];

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      hintText: 'Tìm rạp phim',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text(
                    'TP.HCM >',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cinemaBrands.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder:
                    (_, i) => GestureDetector(
                      onTap: () => setState(() => selectedBrand = i),
                      child: Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              i == selectedBrand
                                  ? const Color(0xFFEF4444)
                                  : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                        ),
                        child: Text(
                          cinemaBrands[i],
                          style: TextStyle(
                            color:
                                i == selectedBrand
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder:
                    (_, i) => GestureDetector(
                      onTap: () => setState(() => selectedDate = i),
                      child: Container(
                        width: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              i == selectedDate
                                  ? const Color(0xFFEF4444)
                                  : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                        ),
                        child: Text(
                          dates[i],
                          style: TextStyle(
                            color:
                                i == selectedDate
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Rạp phim: ${cinemaBrands[selectedBrand]}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCinemas.length,
                itemBuilder: (_, i) {
                  final cinema = selectedCinemas[i];
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 18,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cinema['name'],
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        cinema['address'],
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                        ...cinema['schedules'].map<Widget>((schedule) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule['type'],

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                children: List.generate(
                                  schedule['times'].length,
                                  (j) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => SeatMapPage(
                                                  theaterName: cinema['name'],
                                                  receiveDate:
                                                      dates[selectedDate],
                                                  movieTitle: widget.movieTitle,
                                                  showTime:
                                                      schedule['times'][j],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF666666),
                                              Color(0xFFB3B3B3),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              schedule['times'][j],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              'Còn ${schedule['seats'][j]}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
