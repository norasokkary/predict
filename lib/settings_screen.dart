import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_bottom_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  void _updateSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  int selectedNavIndex = 2; // الإعدادات هي الصفحة الثالثة في البار السفلي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue, // جعل اللون الأزرق
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedNavIndex,
        onTabTapped: (index) {
          if (index != selectedNavIndex) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode Option
            _buildSettingOption(
              title: "Dark Mode",
              subtitle: "Enable or disable dark mode",
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
                _updateSetting('darkMode', value);
              },
            ),

            // Notifications Option
            _buildSettingOption(
              title: "Notifications",
              subtitle: "Enable or disable notifications",
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
                _updateSetting('notifications', value);
              },
            ),

            // Change Language Option
            _buildSettingOption(
              title: "Change Language",
              subtitle: "Select your preferred language",
              value: false, // no value change here, just visual
              onChanged: (bool value) {
                // لا يوجد تغييرات حالياً عند اختيار اللغة
              },
              isLanguageOption: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLanguageOption = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white70, // اللون الباهت للبيضاوي
        borderRadius: BorderRadius.circular(30.0), // الزوايا المدورة لتشبه الشكل البيضاوي
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // اللون الأزرق للنص
          ),
        ),
        subtitle: Text(subtitle),
        trailing: isLanguageOption
            ? Icon(Icons.language)
            : Switch(value: value, onChanged: onChanged),
        onTap: isLanguageOption
            ? () {
          // هنا سيتم تنفيذ شيء لاحقاً عند الضغط (مثل عرض نافذة لاختيار اللغة)
        }
            : null,
      ),
    );
  }
}
