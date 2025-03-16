import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Send the message to the server or API
                print('Message sent');
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
