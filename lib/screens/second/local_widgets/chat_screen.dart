import 'package:flutter/material.dart';
import '../../../utils/Message.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  final ChatState _chatState = ChatState();
  Timer? _dateRefreshTimer;

  @override
  void initState() {
    super.initState();
    setState(() {});

    _dateRefreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _dateRefreshTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _chatState.addMessage(Message(
        content: text,
        timestamp: DateTime.now(),
        isUser: true,
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    final botResponse = await Message.getBotResponse(text);

    setState(() {
      _isTyping = false;
      _chatState.addMessage(Message(
        content: botResponse,
        timestamp: DateTime.now(),
        isUser: false,
      ));
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE3E3E3),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(87),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFC0B6AC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, top: 16.0, right: 12.0, bottom: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                'icons/istockphoto-1010001882-612x612-removebg-preview (1).png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ASPU AI Assistant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.black),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'rate',
                            child: Text(
                              'تقييم المجيب',
                              style: TextStyle(fontSize: 14),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'forward',
                            child: Text(
                              'توجيه المحادثة الى رئيس الدائرة',
                              style: TextStyle(fontSize: 14),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'rate':
                              // Handle rating
                              break;
                            case 'forward':
                              // Handle forwarding
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
        body: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _chatState.messages.length,
              itemBuilder: (context, index) {
                final message = _chatState.messages[index];
                final showDateHeader = index == 0 ||
                    !isSameDay(message.timestamp,
                        _chatState.messages[index - 1].timestamp);

                return Column(
                  children: [
                    if (showDateHeader)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC0B6AC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatDateHeader(message.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: message.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? Color(0xFF26A5D0)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SelectableText(
                              message.content,
                              style: TextStyle(
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: message.isUser ? 12 : 0,
                              left: message.isUser ? 0 : 12,
                              top: 4,
                            ),
                            child: Text(
                              _formatTimeOnly(message.timestamp),
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            if (_isTyping)
              Positioned(
                bottom: 80,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Bot is typing...'),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _messageController,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            onSubmitted: _handleSubmitted,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: const InputDecoration(
                              hintText: "اكتب رسالتك...",
                              hintTextDirection: TextDirection.rtl,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              counterText: "",
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _handleSubmitted(_messageController.text),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF26A5D0),
                            radius: 20,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);
    final difference = today.difference(messageDate).inDays;

    String dateStr;
    if (messageDate == today) {
      dateStr = 'اليوم';
    } else if (messageDate == yesterday) {
      dateStr = 'أمس';
    } else if (difference < 7) {
      // Get day name in Arabic
      final List<String> weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد'
      ];
      dateStr = weekdays[timestamp.weekday - 1];
    } else {
      dateStr =
          '${weekdayShort(timestamp.weekday)} ${timestamp.day}/${timestamp.month}';
    }

    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  String weekdayShort(int weekday) {
    final List<String> shortWeekdays = [
      'الاث',
      'الث',
      'الأر',
      'الخ',
      'الج',
      'الس',
      'الأح'
    ];
    return shortWeekdays[weekday - 1];
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDateHeader(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);
    final difference = today.difference(messageDate).inDays;

    if (messageDate == today) {
      return 'اليوم';
    } else if (messageDate == yesterday) {
      return 'أمس';
    } else if (difference < 7) {
      final List<String> weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد'
      ];
      return '${weekdays[timestamp.weekday - 1]} ${timestamp.day}/${timestamp.month}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatTimeOnly(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
