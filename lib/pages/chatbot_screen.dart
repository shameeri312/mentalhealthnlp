import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/services/nlp_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
        _sendMessage(widget.initialPrompt!);
      }
    });
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    _audioPath =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: _audioPath);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (_audioPath != null) {
      _sendAudioMessage(_audioPath!);
    }
  }

  void _sendMessage(String text) async {
    final timestamp = TimeOfDay.now().format(context);

    setState(() {
      messages.add({
        "sender": "You",
        "text": text,
        "time": timestamp,
        "type": "text",
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
      String? audio = response['audio'] as String?;

      if (botResponse.contains('Chatbot:') || botResponse.contains('User:')) {
        print(
            'Warning: botResponse contains conversation summary: $botResponse');
        botResponse = botResponse
            .split('\n')
            .lastWhere((line) => line.isNotEmpty, orElse: () => 'No response');
      }

      setState(() {
        messages.add({
          "sender": "MindEase Bot",
          "text": botResponse,
          "suggestion": suggestion,
          "video": video,
          "audio": audio,
          "time": TimeOfDay.now().format(context),
          "type": audio != null ? "audio" : "text",
        });
        _isLoading = false;
      });

      _scrollToBottom();

      if (audio == null) {
        await flutterTts.speak(botResponse);
      }
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "MindEase Bot",
          "text": "Error: $e. Please check the server.",
          "time": TimeOfDay.now().format(context),
          "type": "text",
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _sendAudioMessage(String filePath) async {
    final timestamp = TimeOfDay.now().format(context);

    setState(() {
      messages.add({
        "sender": "You",
        "audio": filePath,
        "time": timestamp,
        "type": "audio",
      });
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Placeholder: Implement sendAudio in NlpService to handle audio files
      final response = await _nlpService.sendAudio(filePath);
      print('Audio API Response: $response');

      String botResponse = response['response'] as String? ?? 'No response';
      String? suggestion = response['suggestion'] as String?;
      String? video = response['video'] as String?;
      String? audio = response['audio'] as String?;

      setState(() {
        messages.add({
          "sender": "MindEase Bot",
          "text": botResponse,
          "suggestion": suggestion,
          "video": video,
          "audio": audio,
          "time": TimeOfDay.now().format(context),
          "type": audio != null ? "audio" : "text",
        });
        _isLoading = false;
      });

      _scrollToBottom();

      if (audio == null) {
        await flutterTts.speak(botResponse);
      }
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "MindEase Bot",
          "text": "Error: $e. Please check the server.",
          "time": TimeOfDay.now().format(context),
          "type": "text",
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
    _recorder.closeRecorder();
    _audioPlayer.dispose();
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
          "MindEase",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        color: Colors.white,
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
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange[600],
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
                        if (!isUser)
                          CircleAvatar(
                            backgroundColor: Colors.orange[600],
                            radius: 15,
                            child: const Icon(Icons.chat,
                                color: Colors.white, size: 16),
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
                                    color: Colors.orange[600],
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
                                    ? Colors.orange[600]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (message["type"] == "text")
                                    Text(
                                      message["text"],
                                      style: TextStyle(
                                        color: isUser
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (message["type"] == "audio")
                                    AudioPlayerWidget(
                                      audioPath: message["audio"],
                                      audioPlayer: _audioPlayer,
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
                                              color: Colors.orange[600],
                                            ),
                                          ),
                                          Text(
                                            message["suggestion"],
                                            style: TextStyle(
                                              color: Colors.orange[600],
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
                                            color: Colors.orange[600],
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
                        if (isUser)
                          CircleAvatar(
                            backgroundColor: Colors.orange[600],
                            radius: 15,
                            child: const Icon(Icons.person,
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.black54),
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
                    backgroundColor: Colors.orange[600],
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
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor:
                        _isRecording ? Colors.red : Colors.orange[600],
                    radius: 20,
                    child: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed:
                          _isRecording ? _stopRecording : _startRecording,
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

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final AudioPlayer audioPlayer;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    required this.audioPlayer,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () async {
            if (_isPlaying) {
              await widget.audioPlayer.pause();
            } else {
              await widget.audioPlayer.setFilePath(widget.audioPath);
              await widget.audioPlayer.play();
            }
          },
        ),
        const Text(
          "Audio Message",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
