import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfileScreen.dart';
import 'custom_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String phone = '';
  String email = '';
  String bloodSugarLevel = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Your Name';
      phone = prefs.getString('phone') ?? 'Your Phone';
      email = prefs.getString('email') ?? 'Your Email';
      bloodSugarLevel = prefs.getString('bloodSugarLevel') ?? 'Your Blood Sugar Level';
    });
  }

  // حفظ البيانات في SharedPreferences
  void _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
    prefs.setString('phone', phone);
    prefs.setString('email', email);
    prefs.setString('bloodSugarLevel', bloodSugarLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",  // تغيير اسم الصفحة هنا
          style: TextStyle(
            color: Colors.blue,  // تغيير اللون إلى الأزرق
            fontWeight: FontWeight.bold,  // جعل النص بولد
          ),
        ),
        centerTitle: true,  // محاذاة النص في وسط الـ AppBar
        leading: Container(), // إزالة السهم
      ),
      body: SingleChildScrollView(  // إضافة Scrollable View
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // محاذاة كل المحتوى في المنتصف
            children: [
              // صورة البروفايل في المنتصف
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 10),
              // عرض الاسم الأول من Full Name
              Text(
                fullName.split(' ').first,  // أخذ أول جزء من الاسم
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildInfoCard("Full Name", fullName),
              buildInfoCard("Tele.", phone),
              buildInfoCard("Email", email),
              buildInfoCard("Blood Sugar Level", bloodSugarLevel),
              const SizedBox(height: 20),
              // تعديل زر "Edit Profile" ليملأ الصفحة ويكون بلون أزرق
              ElevatedButton(
                onPressed: () async {
                  // الانتقال إلى شاشة تعديل البيانات
                  final updatedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        fullName: fullName,
                        phone: phone,
                        email: email,
                        bloodSugarLevel: bloodSugarLevel,
                      ),
                    ),
                  );
                  if (updatedData != null) {
                    setState(() {
                      fullName = updatedData['fullName'];
                      phone = updatedData['phone'];
                      email = updatedData['email'];
                      bloodSugarLevel = updatedData['bloodSugarLevel'];
                    });
                    _saveUserData(); // حفظ البيانات بعد التعديل
                  }
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.blue), // تغيير اللون إلى الأزرق
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),  // ملء العرض بالكامل
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onTabTapped: (index) {
          setState(() {
            Navigator.pushReplacementNamed(context, ['/','/profile','/settings'][index]);
          });
        },
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
