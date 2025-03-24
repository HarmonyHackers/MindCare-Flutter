class VideoData {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String youtubeId;
  final Duration duration;
  final List<String> tags;
  final DateTime date;

  VideoData({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.youtubeId,
    required this.duration,
    required this.tags,
    required this.date,
  });
}
