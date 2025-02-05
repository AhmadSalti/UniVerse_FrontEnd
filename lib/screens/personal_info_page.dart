import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/cache_helper.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool _isLoading = true;
  Map<String, dynamic> _studentInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchStudentInfo();
  }

  Future<void> _fetchStudentInfo() async {
    try {
      final token = CacheHelper.getToken();
      final studentId = CacheHelper.getStudentId();

      final response = await http.get(
        Uri.parse('${ApiConfig.STUDENT_INFO_ENDPOINT}/$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _studentInfo = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load student info');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل معلومات الطالب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text(
          'المعلومات الشخصية',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC0B6AC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC0B6AC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFFC0B6AC),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${_studentInfo['User']?['firstName'] ?? ''} ${_studentInfo['User']?['lastName'] ?? ''}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'البريد الإلكتروني',
                              _studentInfo['email'] ?? 'غير متوفر',
                              Icons.email,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'تاريخ الميلاد',
                              _formatDate(_studentInfo['birthDate']),
                              Icons.calendar_today,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'الجنس',
                              _studentInfo['gender'] ?? 'غير متوفر',
                              Icons.person_outline,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'رقم الهاتف',
                              _studentInfo['phone'] ?? 'غير متوفر',
                              Icons.phone,
                            ),
                            const Divider(),
                            _buildInfoRow(
                              'العنوان',
                              _studentInfo['address'] ?? 'غير متوفر',
                              Icons.location_on,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            icon,
            color: const Color(0xFFC0B6AC),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'غير متوفر';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month}-${date.day}';
    } catch (e) {
      return 'غير متوفر';
    }
  }
}
