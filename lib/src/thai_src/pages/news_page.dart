import 'package:flutter/material.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/src/thai_src/widget/custom_card_news.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> newsList = [
    {
      "title": "Tận dụng tối đa không gian",
      "channel": "Phim hành động",
      "timeAgo": "38 phút trước",
      "images": ["https://picsum.photos/id/1027/800/500"],
    },
    {
      "title": "Bom tấn mới ra mắt",
      "channel": "Phim kinh dị",
      "timeAgo": "1 giờ trước",
      "images": [
        "https://picsum.photos/id/1011/800/500",
        "https://picsum.photos/id/1015/800/500",
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Tin Tức",
        listIcon: [],
        showLeading: false,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            hintText: "Bạn muốn tìm tin tức nào?",
            showFilter: false,
            onChanged: (value) {
              // xử lý search real-time
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return CustomCardNews(
                  title: news["title"],
                  channel: news["channel"],
                  timeAgo: news["timeAgo"],
                  images: List<String>.from(news["images"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
