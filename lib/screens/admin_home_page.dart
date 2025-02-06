import 'package:flutter/material.dart';
import '../widgets/admin_top_container.dart';
import '../widgets/adminDrawer.dart';
import '../widgets/botButton.dart';
import '../utils/Message.dart';

class AdminHomePage extends StatefulWidget {
  final String title;
  final String email;
  final String token;

  const AdminHomePage({
    super.key,
    required this.title,
    required this.email,
    required this.token,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    ChatState().initializeForUser(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => admin_top_container(
          email: widget.email,
        ),
      ),
      floatingActionButton: const botButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: const AdminDrawer(),
    );
  }
}
