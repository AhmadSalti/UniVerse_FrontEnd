// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/top_container.dart';
import 'widgets/stDrawer.dart';
import 'widgets/botButton.dart';
import 'screens/login_page.dart';
import 'utils/cache_helper.dart';
import 'utils/Message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFC0B6AC),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC0B6AC)),
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF6F6F8),
        cardColor: const Color(0xFFF6F6F8),
      ),
      home: FutureBuilder<Widget>(
        future: _checkLoginState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data ?? const LoginPage();
        },
      ),
    );
  }

  Future<Widget> _checkLoginState() async {
    final token = CacheHelper.getToken();
    final studentId = CacheHelper.getStudentId();

    if (token != null && studentId != null) {
      return MyHomePage(
        title: 'Home Page',
        studentId: studentId,
        token: token,
      );
    }
    return const LoginPage();
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String studentId;
  final String token;

  const MyHomePage({
    super.key,
    required this.title,
    required this.studentId,
    required this.token,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ChatState().initializeForUser(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => top_container(
          studentId: widget.studentId,
        ),
      ),
      floatingActionButton: const botButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: const StDrawer(),
    );
  }
}
