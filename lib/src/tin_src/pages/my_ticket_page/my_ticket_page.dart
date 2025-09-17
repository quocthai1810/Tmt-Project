import 'package:flutter/material.dart';
import '../../../../core/widgets/thai/custom_appBar.dart';
import 'ticket_card.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  // demo list vé
  List<TicketCard> get tickets => [
    TicketCard(
      movieName: "TÊN BỘ PHIM",
      cinema: "CGV Hoàng Văn Thụ, Tân Bình...",
      date: "20 Nov",
      hour: "15:05",
      seats: "G10, G11",
      bookingCode: "091821912301",
      posterPath: "assets/img/test.jpg",
      qrPath: "assets/img/test.jpg",
    ),
    TicketCard(
      movieName: "AVENGERS: ENDGAME",
      cinema: "CGV Landmark 81, Bình Thạnh",
      date: "25 Nov",
      hour: "19:30",
      seats: "C5, C6, C7",
      bookingCode: "123456789012",
      posterPath: "assets/img/test.jpg",
      qrPath: "assets/img/test.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: const CustomAppbar(
        textTitle: "My Ticket",
        showLeading: true,
        listIcon: [],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return tickets[index];
        },
      ),
    );
  }
}
