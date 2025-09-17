import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:tmt_project/core/widgets/minh/customTextField.dart';
import 'package:tmt_project/core/widgets/minh/customToast.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/minh_src/pages/trailer_pages/trailer_pages.dart';
import 'package:tmt_project/src/minh_src/pages/detail_pages/detailProvider.dart';
import 'package:tmt_project/src/minh_src/pages/trailer_pages/trailerProviders.dart';

class DetailPages extends StatefulWidget {
  final int movieId;
  const DetailPages({super.key, required this.movieId});

  @override
  State<DetailPages> createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  final double _backgroundHeight = 380;
  final double _focusImageHeight = 280;
  final double _focusImageWidth = 200;
  final double _focusImageRadius = 10;
  late final double _overlap = _focusImageHeight * 0.3;

  bool _isExpanded = false;
  final int _maxPreviewLength = 200;
  final TextEditingController _commentController = TextEditingController();

  final String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<Detailprovider>(
        context,
        listen: false,
      ).fetchDetails(widget.movieId);
      Provider.of<CommentProvider>(
        context,
        listen: false,
      ).fetchComments(widget.movieId);
    });
  }

  Future<void> _pushWithLoader({
    required BuildContext context,
    required String routeName,
    Object? arguments,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CustomLoading(width: 88, height: 88)),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    Navigator.of(context).pop(); // tắt loading
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  Future<void> _pushPageWithLoader(Widget page) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CustomLoading(width: 88, height: 88)),
    );

    await Future.delayed(const Duration(milliseconds: 400));
    Navigator.of(context).pop();

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Detailprovider, CommentProvider>(
      builder: (context, detail, comment, _) {
        if ((detail.isLoadingDetail ?? true) || detail.thongTinPhim == null) {
          return const Scaffold(
            body: Center(child: CustomLoading(width: 88, height: 88)),
          );
        }

        final movie = detail.thongTinPhim!;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: _backgroundHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                  Colors.black,
                                ],
                              ).createShader(bounds),
                          blendMode: BlendMode.darken,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageBaseUrl + (movie["anh_header"] ?? ''),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  imageBaseUrl + (movie["anh_poster"] ?? ''),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -_overlap,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                width: _focusImageWidth,
                                height: _focusImageHeight,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.35),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                    _focusImageRadius + 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    _focusImageRadius,
                                  ),
                                  child: Image.network(
                                    imageBaseUrl + (movie["anh_poster"] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${movie["ma_gioi_han_tuoi"]}+",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, _overlap + 12, 16, 18),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          movie["ten_phim"] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (movie["theLoai"] != null)
                        Center(
                          child: Chip(
                            label: Text(movie["theLoai"]["ten_the_loai"] ?? ""),
                            backgroundColor: Colors.pink.shade100,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Mua vé",
                              onPressed:
                                  () => _pushWithLoader(
                                    context: context,
                                    routeName: AppRouteNames.bookingTicketPages,
                                    arguments: movie["ten_phim"],
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: "Trailer",
                              onPressed:
                                  () => _pushPageWithLoader(
                                    TrailerPages(
                                      movieId:
                                          movie["ma_phim"] ?? widget.movieId,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Nội dung phim",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text:
                              _isExpanded ||
                                      (movie["tom_tat"]?.length ?? 0) <=
                                          _maxPreviewLength
                                  ? movie["tom_tat"] ?? ''
                                  : movie["tom_tat"].toString().substring(
                                        0,
                                        _maxPreviewLength,
                                      ) +
                                      '... ',
                          children: [
                            if ((movie["tom_tat"]?.length ?? 0) >
                                _maxPreviewLength)
                              TextSpan(
                                text: _isExpanded ? "Thu gọn" : "Thêm nữa",
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() {
                                          _isExpanded = !_isExpanded;
                                        });
                                      },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (movie["phim_dienvien"] != null &&
                          movie["phim_dienvien"] is List)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Diễn viên",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 140,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: movie["phim_dienvien"].length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final actor = movie["phim_dienvien"][index];
                                  final info = actor["dienVien"] ?? {};
                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            (info["avatar"] != null &&
                                                    info["avatar"]
                                                        .toString()
                                                        .isNotEmpty)
                                                ? Image.network(
                                                  imageBaseUrl + info["avatar"],
                                                  width: 70,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    // Nếu link ảnh lỗi → fallback sang text
                                                    return Container(
                                                      width: 70,
                                                      height: 90,
                                                      color:
                                                          Colors.grey.shade300,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        "Chưa có hình",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                                : Container(
                                                  width: 70,
                                                  height: 90,
                                                  color: Colors.grey.shade300,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "Chưa có hình",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        info["ten_dien_vien"] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        actor["character"] ?? '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bình luận",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...comment.comments.map(
                        (cmt) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(
                                  "https://i.pravatar.cc/100",
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(cmt),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Nhập bình luận của bạn...",
                              controller: _commentController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustomButton(
                            text: "Gửi",
                            onPressed: () {
                              final text = _commentController.text.trim();
                              if (text.isEmpty) {
                                CustomToast.show(
                                  context,
                                  message: "Chưa nhập bình luận",
                                  type: ToastType.confirm,
                                );
                                return;
                              }
                              comment.comments.add(text);
                              _commentController.clear();
                              setState(() {});
                              CustomToast.show(
                                context,
                                message: "Đã gửi bình luận",
                                type: ToastType.success,
                              );
                            },
                            width: 90,
                            height: 50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }
}
