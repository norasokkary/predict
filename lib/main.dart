import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recommendation_screen.dart';
import 'doctors_screen.dart';
import 'reminder_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'upload_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/reminder': (context) => ReminderScreen(),
        '/doctors': (context) => DoctorsScreen(),
        '/recommendation': (context) => RecommendationScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/corneal-exam': (context) => UploadPage(),
      },
    );
  }
}
