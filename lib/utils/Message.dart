import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'cache_helper.dart';

class Message {
  final String content;
  final DateTime timestamp;
  final bool isUser;

  Message({
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'isUser': isUser,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
        isUser: json['isUser'],
      );

  static Future<String> getBotResponse(String message) async {
    try {
      final response = await http
          .post(
        Uri.parse('http://127.0.0.1:5005/webhooks/rest/webhook/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": message,
          "sender": "flutter_user",
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> rasaResponse = jsonDecode(response.body);
        if (rasaResponse.isEmpty) {
          return "عذراً، لم أفهم رسالتك. هل يمكنك المحاولة مرة أخرى؟";
        }

        final messages = rasaResponse
            .where((msg) => msg.containsKey("text"))
            .map((msg) => msg["text"].toString())
            .toList();

        return messages.isNotEmpty
            ? messages.join("\n")
            : "عذراً، لم أستطع معالجة رسالتك بشكل صحيح.";
      }

      return "عذراً، أواجه صعوبة في فهم رسالتك حالياً.";
    } catch (e) {
      if (e is TimeoutException) {
        return "حصلت مشكلة تقنية, يرجى اعادة المحاولة لاحقاً";
      }
      return "عذراً، أواجه مشكلة تقنية حالياً.";
    }
  }
}

class ChatState {
  static final ChatState _instance = ChatState._internal();
  List<Message> messages = [];
  String? _studentId;

  factory ChatState() {
    return _instance;
  }

  void initializeForUser(String studentId) {
    _studentId = studentId;
    messages = CacheHelper.getMessages(studentId);
  }

  ChatState._internal();

  void addMessage(Message message) {
    if (_studentId == null) return;
    messages.add(message);
    CacheHelper.saveMessages(messages, _studentId!);
  }

  void clearMessages() {
    if (_studentId == null) return;
    messages.clear();
    CacheHelper.saveMessages(messages, _studentId!);
  }
}
