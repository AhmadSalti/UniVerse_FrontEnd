import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import '../utils/cache_helper.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final Map<String, bool> _expansionStates = {
    'files': false,
    'calendar': false,
    'grades': false,
    'registration': false,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        backgroundColor: Color(0xFFF6F6F8),
        child: SafeArea(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.asset(
                  'icons/Planet_Arcadia-removebg-preview (2).png',
                  fit: BoxFit.contain,
                ),
              ),
              ExpansionTile(
                trailing: Icon(Icons.person_outline),
                leading: RotationTransition(
                  turns: _expansionStates['files'] ?? false
                      ? AlwaysStoppedAnimation(-0.25)
                      : AlwaysStoppedAnimation(0),
                  child: Icon(Icons.arrow_back_ios, size: 16),
                ),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'ملفات الطلاب',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expansionStates['files'] = expanded;
                  });
                },
                children: [
                  _buildSubListTile('إدارة ملفات الطلاب', () {}),
                  _buildSubListTile('انشاء حساب طالب جديد', () {}),
                ],
              ),
              ExpansionTile(
                trailing: Icon(Icons.calendar_month),
                leading: RotationTransition(
                  turns: _expansionStates['calendar'] ?? false
                      ? AlwaysStoppedAnimation(-0.25)
                      : AlwaysStoppedAnimation(0),
                  child: Icon(Icons.arrow_back_ios, size: 16),
                ),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'التقويم',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expansionStates['calendar'] = expanded;
                  });
                },
                children: [
                  _buildSubListTile('إدارة جدول المحاضرات', () {}),
                  _buildSubListTile('إدارة جدول الامتحانات', () {}),
                ],
              ),
              ExpansionTile(
                trailing: Icon(Icons.my_library_books_outlined),
                leading: RotationTransition(
                  turns: _expansionStates['grades'] ?? false
                      ? AlwaysStoppedAnimation(-0.25)
                      : AlwaysStoppedAnimation(0),
                  child: Icon(Icons.arrow_back_ios, size: 16),
                ),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'الدرجات',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expansionStates['grades'] = expanded;
                  });
                },
                children: [
                  _buildSubListTile('إدارة درجات المقرر', () {}),
                  _buildSubListTile('كشف علامات طالب', () {}),
                ],
              ),
              ExpansionTile(
                trailing: Icon(Icons.menu_book),
                leading: RotationTransition(
                  turns: _expansionStates['registration'] ?? false
                      ? AlwaysStoppedAnimation(-0.25)
                      : AlwaysStoppedAnimation(0),
                  child: Icon(Icons.arrow_back_ios, size: 16),
                ),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'التسجيل',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expansionStates['registration'] = expanded;
                  });
                },
                children: [
                  _buildSubListTile('قواعد التسجيل', () {}),
                  _buildSubListTile('إدارة تسجيل المقررات', () {}),
                  _buildSubListTile('إدارة سحب وإضافة المقررات', () {}),
                  _buildSubListTile('تغيير الفئات', () {}),
                ],
              ),
              ListTile(
                trailing: Icon(Icons.chat_bubble_outline),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'عرض مراجعات المجيب الآلي',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                trailing: Icon(Icons.notifications_active_outlined),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'الإعلانات',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                trailing: Icon(Icons.settings),
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'الإعدادات',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: () {},
              ),
              _buildLogoutTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubListTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 32),
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
        ),
      ),
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          title,
          style: TextStyle(fontSize: 12),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      trailing: const Icon(Icons.logout),
      title: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text('تسجيل الخروج', style: TextStyle(fontSize: 12)),
      ),
      onTap: () async {
        await CacheHelper.clearUserData();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
    );
  }
}
