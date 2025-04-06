import 'package:flutter/material.dart';
import 'package:mind_care/config/colors.dart';
import 'package:mind_care/utils/daily_sample_videos.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/video_data_model.dart';

class DailyVideos extends StatefulWidget {
  const DailyVideos({super.key});

  @override
  State<DailyVideos> createState() => _DailyVideosState();
}

class _DailyVideosState extends State<DailyVideos> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;
  late VideoData _todayVideo;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      _todayVideo = sampleVideos.first;

      //! YouTube player controller
      _controller = YoutubePlayerController(
        initialVideoId: _todayVideo.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: true,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading videos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _playVideo(VideoData video) {
    setState(() {
      _todayVideo = video;
      _controller.load(video.youtubeId);
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/daily_videos_logo.png",
          height: 6.h,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.cardRed))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeaturedVideo(),
                  _buildPreviousVideos(),
                ],
              ),
            ),
    );
  }

  Widget _buildFeaturedVideo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Featured Video",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.banner,
                ),
          ),
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: const TextStyle(
              color: AppColors.banner,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.teal,
              progressColors: const ProgressBarColors(
                playedColor: AppColors.cardRed,
                handleColor: AppColors.cardRed,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _todayVideo.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(_todayVideo.description),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _todayVideo.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.cardLavender,
                      side: BorderSide(
                        color: Colors.teal.shade200,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousVideos() {
    final previousVideos = sampleVideos.sublist(1);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Previous Videos",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...previousVideos.map((video) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () => _playVideo(video),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              video.thumbnailUrl,
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 120,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d').format(video.date),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            Text(
                              _formatDuration(video.duration),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Center(
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video library coming soon')),
                );
              },
              child: const Text(
                "View More Videos",
                style: TextStyle(
                  color: AppColors.banner,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
