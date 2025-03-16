import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Welcome to the Community Page!'),
            SizedBox(height: 16),
            Text(
                'This is a place for users to share their experiences, ask questions, and connect with others.'),
          ],
        ),
      ),
    );
  }
}
