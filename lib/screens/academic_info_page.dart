import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/cache_helper.dart';

class AcademicInfoPage extends StatefulWidget {
  const AcademicInfoPage({super.key});

  @override
  State<AcademicInfoPage> createState() => _AcademicInfoPageState();
}

class _AcademicInfoPageState extends State<AcademicInfoPage> {
  bool _isLoading = true;
  Map<String, dynamic> _academicInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchAcademicInfo();
  }

  Future<void> _fetchAcademicInfo() async {
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
          _academicInfo = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load academic info');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل المعلومات الأكاديمية')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text(
          'المعلومات الأكاديمية',
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
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC0B6AC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _academicInfo['gpa']?.toString() ?? '0.00',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'المعدل التراكمي',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDetailsCard(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailsCard() {
    final fullName =
        "${_academicInfo['firstName'] ?? ''} ${_academicInfo['lastName'] ?? ''}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'التفاصيل الأكاديمية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'الاسم الكامل',
              fullName,
              Icons.person,
            ),
            const Divider(),
            _buildInfoRow(
              'الرقم الاجتماعي',
              _academicInfo['socialNumber'] ?? 'غير متوفر',
              Icons.badge,
            ),
            const Divider(),
            _buildInfoRow(
              'التخصص',
              _academicInfo['major'] ?? 'غير متوفر',
              Icons.school,
            ),
            const Divider(),
            _buildInfoRow(
              'الساعات المنجزة',
              '${_academicInfo['hoursAchieved'] ?? 0} ساعة',
              Icons.access_time,
            ),
            const Divider(),
            _buildInfoRow(
              'السنة الدراسية',
              _academicInfo['academicYear']?.toString() ?? 'غير متوفر',
              Icons.calendar_today,
            ),
            const Divider(),
            _buildInfoRow(
              'تاريخ التسجيل',
              _formatDate(_academicInfo['enrollmentDate']),
              Icons.event,
            ),
            const Divider(),
            _buildInfoRow(
              'الرصيد',
              _formatNumber(_academicInfo['balance']),
              Icons.account_balance_wallet,
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

  String _formatNumber(num? number) {
    if (number == null) return '0';
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
