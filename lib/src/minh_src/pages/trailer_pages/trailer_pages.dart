// ==================== ✅ FILE 1: TrailerPages.dart ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tmt_project/src/minh_src/pages/trailer_pages/trailerProviders.dart';

class TrailerPages extends StatefulWidget {
  final int movieId;

  const TrailerPages({super.key, required this.movieId});

  @override
  State<TrailerPages> createState() => _TrailerPagesState();
}

class _TrailerPagesState extends State<TrailerPages> {
  YoutubePlayerController? _youtubeController;
  bool _showFullDescription = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<TrailerProvider>(context, listen: false);
      await provider.fetchMovieDetails(widget.movieId);

      final videoUrl = provider.trailerUrl;
      if (videoUrl != null && YoutubePlayer.convertUrlToId(videoUrl) != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
            isLive: false,
            forceHD: true,
          ),
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrailerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingDetail) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.errorDetail != null) {
          return Scaffold(body: Center(child: Text(provider.errorDetail!)));
        }

        if (_youtubeController == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).colorScheme.primary,
          ),
          builder:
              (context, player) => Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                appBar: AppBar(
                  title: Text(
                    provider.movieTitle ?? 'Đang tải...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:
                            _isFavorite
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Colors.white,
                      ),
                      onPressed:
                          () => setState(() => _isFavorite = !_isFavorite),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_youtubeController != null) ...[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: player,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        provider.movieTitle ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                provider.releaseDate?.substring(0, 10) ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_movies,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                provider.genres.join(', '),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text:
                              _showFullDescription
                                  ? provider.summary
                                  : (provider.summary!.length > 150
                                      ? provider.summary!.substring(0, 150)
                                      : provider.summary),
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: _showFullDescription ? ' Less' : ' More',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        _showFullDescription =
                                            !_showFullDescription;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Cast and Crew',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.cast.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, index) {
                            final actor = provider.cast[index];
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    'https://image.tmdb.org/t/p/w200${actor['avatar']}',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    actor['name'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    actor['character'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}
