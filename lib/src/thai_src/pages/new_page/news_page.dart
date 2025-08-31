import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/src/thai_src/pages/new_page/new_provider.dart';
import 'package:tmt_project/src/thai_src/widget/custom_card_news.dart';
import 'package:tmt_project/src/thai_src/widget/custom_search.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String showSearchNews = "";

  @override
  void initState() {
    super.initState();
    // Lần đầu load tin
    Future.microtask(() {
      Provider.of<NewsProvider>(context, listen: false).loadNews();
    });

    // Lắng nghe khi scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Gần chạm đáy -> load thêm
        Provider.of<NewsProvider>(context, listen: false).loadNews();
      }
    });

    _searchController.addListener(() {
      setState(() {
        showSearchNews = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
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
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, provider, child) {
                final newsList = provider.newsList;
                if (provider.isLoading && newsList.isEmpty) {
                  return const Center(
                    child: CustomLoading(width: 88, height: 88),
                  );
                }
                if (provider.error != null && newsList.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/img/searchResult.png"),
                      SizedBox(height: 24),
                      Text(
                        "Rất tiếc, chúng tôi không tìm thấy tin tức của bạn",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                }

                /// tìm tin tức
                final filterNews =
                    newsList.where((news) {
                      final title =
                          (news["tieu_de"] ?? "").toString().toLowerCase();
                      final description =
                          (news["mo_ta"] ?? "").toString().toLowerCase();
                      return title.contains(showSearchNews) ||
                          description.contains(showSearchNews);
                    }).toList();
                if (filterNews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/searchResult.png"),
                        SizedBox(height: 24),
                        Text(
                          "Rất tiếc, chúng tôi không tìm thấy tin tức của bạn",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: filterNews.length,
                  itemBuilder: (context, index) {
                    if (index < filterNews.length) {
                      final news = filterNews[index];
                      return CustomCardNews(
                        title: news["tieu_de"] ?? "",
                        description: news["mo_ta"] ?? "",
                        urlDetail: news["url_chi_tiet"],
                        channel:
                            (news["tac_gia"] ?? "").isEmpty
                                ? "Ngày đăng tin"
                                : news["tac_gia"],
                        timeAgo: news["ngay_tao"] ?? "",
                        images: [news["hinh_anh"] ?? ""],
                      );
                    }
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
