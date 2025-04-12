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

      if (response is! Map<String, dynamic>) {
        throw Exception(
            'Invalid API response: Expected a Map, got ${response.runtimeType}');
      }

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ChatBot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2176FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          image: DecorationImage(
            image: AssetImage('assets/images/chat_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black26,
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2176FF),
                          ),
                        ),
                      ),
                    );
                  }

                  final message = messages[index];
                  bool isUser = message["sender"] == "You";
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[200] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message["sender"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isUser ? Colors.blue[700] : Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            message["text"],
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.blue[900],
                            ),
                          ),
                          if (!isUser && message["suggestion"] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Suggestion: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: message["suggestion"],
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (!isUser && message["video"] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: () async {
                                  final url = Uri.parse(message["video"]);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    print(
                                        "Could not launch ${message['video']}");
                                  }
                                },
                                child: const Text(
                                  "Watch Video",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 5),
                          Text(
                            message["time"],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
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
