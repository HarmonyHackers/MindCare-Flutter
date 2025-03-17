import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mind_care/utils/api_endpoint_strings.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../config/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Welcome message when the chat opens
    _messages.add({
      "sender": "bot",
      "text": "Hi there! I'm PsychoBot. How can I help you today?"
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // small delay to ensure the list has updated before scrolling
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    String userMessage = _messageController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "text": userMessage});
        _isLoading = true;
      });
      _messageController.clear();
      _scrollToBottom();

      String botResponse = await _getChatbotResponse(userMessage);

      setState(() {
        _messages.add({"sender": "bot", "text": botResponse});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<String> _getChatbotResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpointStrings.sendRequest),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage}),
      );

      debugPrint("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["response"] ?? "No response received.";
      } else {
        return "Error: Server responded with status ${response.statusCode}";
      }
    } catch (e) {
      return "Error: Unable to connect to the chatbot server. Exception: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Image.asset(
          "assets/images/psycho-bot.png",
          height: 5.h,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  "sender": "bot",
                  "text": "Hi there! I'm PsychoBot. How can I help you today?"
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message["sender"] == "user";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser)
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("assets/images/Psychobot.jpeg"),
                        ),
                      if (!isUser) const SizedBox(width: 2),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 80.w,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.cardPurple
                              : AppColors.cardBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(0),
                            bottomRight: isUser
                                ? const Radius.circular(0)
                                : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isUser
                            ? Text(
                                message["text"]!,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                // Use Markdown widget for bot messages
                                child: MarkdownBody(
                                  data: message["text"]!,
                                  styleSheet: MarkdownStyleSheet(
                                    p: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 15.sp,
                                    ),
                                    strong: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                    listBullet: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (isUser) const SizedBox(width: 6),
                      if (isUser)
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.banner,
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/Psychobot.jpeg"),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _buildPulsingDot(index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: AppColors.banner,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: 0.2 + ((index * 0.2 + value) % 1.0) * 0.8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.cardPurple,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
