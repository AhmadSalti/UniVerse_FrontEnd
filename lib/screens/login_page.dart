import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../utils/cache_helper.dart';
import '../config/api_config.dart';
import 'admin_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final loginValue = _loginController.text;
      final isEmail = loginValue.contains('@');

      final Map<String, String> requestBody = isEmail
          ? {
              'email': loginValue,
              'password': _passwordController.text,
            }
          : {
              'id': loginValue,
              'password': _passwordController.text,
            };

      final response = await http.post(
        Uri.parse(isEmail
            ? ApiConfig.ADMIN_LOGIN_ENDPOINT
            : ApiConfig.LOGIN_ENDPOINT),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        final parts = token.split('.');
        if (parts.length != 3) {
          throw Exception('Invalid token');
        }

        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final payloadData = utf8.decode(base64Url.decode(normalized));
        final payloadMap = jsonDecode(payloadData);

        final role = payloadMap['role']?.toString();
        if (role == 'admin') {
          final email = payloadMap['email']?.toString() ?? "";
          await CacheHelper.saveToken(token);
          await CacheHelper.saveEmail(email);
          await CacheHelper.saveRole('admin');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(
                title: 'Admin Dashboard',
                email: email,
                token: token,
              ),
            ),
          );
        } else {
          final id = payloadMap['id']?.toString() ?? "000000000";
          final studentId = id.padLeft(9, '0');
          await CacheHelper.saveToken(token);
          await CacheHelper.saveStudentId(studentId);
          await CacheHelper.saveRole('student');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: 'Home Page',
                studentId: studentId,
                token: token,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل تسجيل الدخول. الرجاء التحقق من البيانات'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في الاتصال: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'icons/Planet_Arcadia-removebg-preview (2).png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Card(
                        color: const Color(0xFFF6F6F8),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: _loginController,
                                  decoration: const InputDecoration(
                                    labelText: 'رقم الطالب',
                                    alignLabelWithHint: true,
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.start,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رقم الطالب';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'كلمة المرور',
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC0B6AC),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _login();
                                          }
                                        },
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('تسجيل الدخول'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
