import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/services/nlp_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotScreen extends StatefulWidget {
  final String? initialPrompt;

  const ChatBotScreen({super.key, this.initialPrompt});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final NlpService _nlpService = NlpService();
  final FlutterTts flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
        _sendMessage(widget.initialPrompt!);
      }
    });
  }

  void _sendMessage(String text) async {
    final timestamp = TimeOfDay.now().format(context);

    setState(() {
      messages.add({
        "sender": "You",
        "text": text,
        "time": timestamp,
      });
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _nlpService.analyzeSentiment(text);
      print('API Response: $response');

      String botResponse = response['response'] as String? ?? 'No response';
      String? suggestion = response['suggestion'] as String?;
      String? video = response['video'] as String?;

      if (botResponse.contains('Chatbot:') || botResponse.contains('User:')) {
        print(
            'Warning: botResponse contains conversation summary: $botResponse');
        botResponse = botResponse
            .split('\n')
            .lastWhere((line) => line.isNotEmpty, orElse: () => 'No response');
      }

      setState(() {
        messages.add({
          "sender": "NLP Bot",
          "text": botResponse,
          "suggestion": suggestion,
          "video": video,
          "time": TimeOfDay.now().format(context),
        });
        _isLoading = false;
      });

      _scrollToBottom();

      await flutterTts.speak(botResponse);
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "NLP Bot",
          "text": "Error: $e. Please check the server.",
          "time": TimeOfDay.now().format(context),
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ChatBot",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100], // Darker blue for app bar
      ),
      body: Container(
        color: Colors.white, // Dark background for dark mode
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == messages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueAccent[600],
                          ),
                        ),
                      ),
                    );
                  }

                  final message = messages[index];
                  bool isUser = message["sender"] == "You";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) // Show avatar or icon for bot
                          CircleAvatar(
                            backgroundColor: const Color(0xFF2176FF),
                            radius: 15,
                            child:
                                Icon(Icons.chat, color: Colors.white, size: 16),
                          ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message["sender"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUser
                                        ? Colors.blueAccent[600]
                                        : Colors.blueAccent[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  message["time"],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(
                                        0xFF2176FF) // Bluish user bubble
                                    : Colors.grey[100], // Grayish bot bubble
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message["text"],
                                    style: TextStyle(
                                      color:
                                          isUser ? Colors.white : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (!isUser && message["suggestion"] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Suggestion: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent[600],
                                            ),
                                          ),
                                          Text(
                                            message["suggestion"],
                                            style: TextStyle(
                                              color: Colors.blueAccent[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!isUser && message["video"] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final url =
                                              Uri.parse(message["video"]);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            print(
                                                "Could not launch ${message['video']}");
                                          }
                                        },
                                        child: Text(
                                          "Watch Video",
                                          style: TextStyle(
                                            color: Colors.blueAccent[600],
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isUser) const SizedBox(width: 8),
                        if (isUser) // Show avatar or icon for user
                          CircleAvatar(
                            backgroundColor: const Color(0xFF2176FF),
                            radius: 15,
                            child: Icon(Icons.person,
                                color: Colors.white, size: 16),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Dark input field
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.1),
                        //     spreadRadius: 1,
                        //     blurRadius: 5,
                        //     offset: const Offset(0, 2),
                        //   ),
                        // ],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF2176FF),
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
