import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'cache_helper.dart';
import '../config/api_config.dart';

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

  static Future<String> getBotResponse(String message, String token) async {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadData = utf8.decode(base64Url.decode(normalized));
    final payloadMap = jsonDecode(payloadData);
    final id = payloadMap['id']?.toString() ?? "000000000";
    final studentId = id.padLeft(9, '0');

    try {
      final requestBody = {
        'message': message,
        'metadata': {'student_id': studentId}
      };

      final response = await http
          .post(
        Uri.parse(ApiConfig.BOT_ENDPOINT),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
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
  Map<String, List<Message>> _userMessages = {};
  String? _currentUserId;

  factory ChatState() {
    return _instance;
  }

  void initializeForUser(String studentId) {
    _currentUserId = studentId;
    if (!_userMessages.containsKey(studentId)) {
      _userMessages[studentId] = CacheHelper.getMessages(studentId);
    }
  }

  List<Message> get messages =>
      _currentUserId != null ? _userMessages[_currentUserId] ?? [] : [];

  void addMessage(Message message) {
    if (_currentUserId == null) return;

    if (!_userMessages.containsKey(_currentUserId)) {
      _userMessages[_currentUserId!] = [];
    }

    _userMessages[_currentUserId]!.add(message);
    CacheHelper.saveMessages(_userMessages[_currentUserId]!, _currentUserId!);
  }

  void clearMessages() {
    if (_currentUserId == null) return;
    _userMessages.remove(_currentUserId);
    CacheHelper.saveMessages([], _currentUserId!);
  }

  void clearAllMessages() {
    _userMessages.clear();
    _currentUserId = null;
  }

  ChatState._internal();
}
