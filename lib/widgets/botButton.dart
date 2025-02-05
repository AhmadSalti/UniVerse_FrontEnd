import 'package:flutter/material.dart';
import '/screens/second/local_widgets/chat_screen.dart';
import '/utils/cache_helper.dart';

class botButton extends StatefulWidget {
  const botButton({super.key});

  @override
  State<botButton> createState() => _botButtonState();
}

class _botButtonState extends State<botButton> {
  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(token: CacheHelper.getToken() ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 153,
      height: 153,
      child: FloatingActionButton(
        onPressed: _openChat,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Image.asset(
          'icons/istockphoto-1010001882-612x612-removebg-preview (1).png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
