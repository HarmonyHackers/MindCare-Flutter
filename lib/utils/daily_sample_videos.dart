import 'package:mind_care/models/video_data_model.dart';

List<VideoData> sampleVideos = [
  VideoData(
    id: '1',
    title: 'How to Manage Stress & Anxiety',
    description: 'Learn practical tips to manage everyday stress and anxiety.',
    thumbnailUrl: 'https://img.youtube.com/vi/hnpQrMqDoqE/0.jpg',
    youtubeId: 'hnpQrMqDoqE',
    duration: const Duration(minutes: 14, seconds: 23),
    tags: ['anxiety', 'stress', 'mental health'],
    date: DateTime.now(),
  ),
  VideoData(
    id: '2',
    title: 'Understanding the Teenage Brain',
    description: 'The science behind teenage mental health and development.',
    thumbnailUrl: 'https://img.youtube.com/vi/LWUkW4s3XxY/0.jpg',
    youtubeId: 'LWUkW4s3XxY',
    duration: const Duration(minutes: 7, seconds: 14),
    tags: ['teens', 'development', 'brain science'],
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  VideoData(
    id: '3',
    title: 'The Power of Vulnerability',
    description:
        'How embracing vulnerability can lead to better mental health.',
    thumbnailUrl: 'https://img.youtube.com/vi/iCvmsMzlF7o/0.jpg',
    youtubeId: 'iCvmsMzlF7o',
    duration: const Duration(minutes: 20, seconds: 49),
    tags: ['vulnerability', 'connection', 'emotional health'],
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
