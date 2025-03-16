import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

const String geminiApiKey = "AIzaSyBZxBDI7q1EQfoqhd0h2aDAeTnkSt4SBFc";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    String userMessage = _messageController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "text": userMessage});
        _isLoading = true;
      });
      _messageController.clear();

      String aiResponse = await _getGeminiResponse(userMessage);

      setState(() {
        _messages.add({"sender": "bot", "text": aiResponse});
        _isLoading = false;
      });
    }
  }

  Future<String> _getGeminiResponse(String userMessage) async {
    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$geminiApiKey";

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": userMessage}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Sorry, I couldn't understand. Please try again.";
      }
    } catch (e) {
      return "Error connecting to AI service. Please check your internet connection.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/psycho-bot.png",
          height: 5.h,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message["sender"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
