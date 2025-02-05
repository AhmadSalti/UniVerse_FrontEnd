import 'package:flutter/material.dart';

class RegistrationRulesPage extends StatelessWidget {
  const RegistrationRulesPage({super.key});

  Widget _buildRuleCard(String title, String value, String explanation) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC0B6AC),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              explanation,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text(
          'قواعد التسجيل',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildRuleCard(
            'إجمالي العبئ المسموح',
            '12 - 18 ساعات',
            'عدد السّاعات الإجمالي المسموح تسجيله (دراسة كاملة + امتحان فقط)',
          ),
          _buildRuleCard(
            'العبئ المسموح (دراسة)',
            '12 - 18 ساعات',
            'عدد السّاعات المسموح تسجيله كدراسة كاملة',
          ),
          _buildRuleCard(
            'العبئ المسموح (امتحان)',
            '0 ساعات',
            'عدد الساعات المسموح تسجيله كامتحان فقط',
          ),
          _buildRuleCard(
            'نسبة السعي الفصلي المطلوبة',
            '25%',
            'يمكن للطلاب الذين تقدموا بالمقرر سابقاً ولم يحالفهم الحظ لإنجازه أن يعيدوا تسجيل المقرر كامتحان فقط ، شريطة أن يكون حازوا على هذا الحد الأدنى من العلامات في القسم العملي.',
          ),
          _buildRuleCard(
            'نسبة امتحان النظري المطلوبة',
            '25%',
            'يمكن للطلاب الذين تقدموا بالمقرر سابقاً ولم يحالفهم الحظ لإنجازه أن يعيدوا تسجيل المقرر كامتحان فقط ، شريطة أن يكون حازوا على هذا الحد الأدنى من العلامات في القسم النظري.',
          ),
          _buildRuleCard(
            'يمكن إعادة المقررات بعلامة',
            '0 - 99 علامة',
            'يمكن إعادة المقررات المنجزة شريطة أن يكون الطالب قد حاز على هذه العلامة',
          ),
          _buildRuleCard(
            'المقررات الجديدة التي يمكن تسجيلها',
            '12 مقرر',
            'العدد الأعظمي للمقررات الجديدة المسموح تسجيلها',
          ),
          _buildRuleCard(
            'المقررات الراسبة الواجب تسجيلها',
            '0 مقرر',
            'عدد المقررات الراسبة الواجب تسجيلها . القيمة 100 تعني وجوب تسجيل جميع المقررات الراسبة',
          ),
          _buildRuleCard(
            'مقررات النجاح الشرطي',
            '0 مقرر',
            'عدد مقررات النجاح الشرطي المسموح تسجيلها',
          ),
        ],
      ),
    );
  }
}
