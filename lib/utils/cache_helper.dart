import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'Message.dart';

class CacheHelper {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('appCache');
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await _box.put('token', token);
  }

  static String? getToken() {
    return _box.get('token');
  }

  // Student ID management
  static Future<void> saveStudentId(String studentId) async {
    await _box.put('studentId', studentId);
  }

  static String? getStudentId() {
    return _box.get('studentId');
  }

  // Chat messages management
  static Future<void> saveMessages(
      List<Message> messages, String studentId) async {
    final messagesJson = messages.map((msg) => msg.toJson()).toList();
    await _box.put('messages_$studentId', jsonEncode(messagesJson));
  }

  static List<Message> getMessages(String studentId) {
    final messagesString = _box.get('messages_$studentId');
    if (messagesString == null) return [];

    final messagesList = jsonDecode(messagesString) as List;
    return messagesList.map((msg) => Message.fromJson(msg)).toList();
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _box.clear();
  }
}
