import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendation_screen.dart';
import 'doctors_screen.dart';
import 'reminder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'custom_bottom_navigation.dart';
import 'upload_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime today = DateTime.now();
  List<DateTime> weekDays = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  int selectedDayIndex = 0;
  int selectedNavIndex = 0;
  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedReminders = prefs.getString('reminders');
    if (storedReminders != null) {
      setState(() {
        reminders = List<Map<String, dynamic>>.from(json.decode(storedReminders));
      });
    }
  }

  List<Map<String, dynamic>> getRemindersForSelectedDay() {
    String selectedDate = DateFormat('yyyy-MM-dd').format(weekDays[selectedDayIndex]);
    return reminders.where((reminder) => reminder['date'] == selectedDate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedNavIndex,
        onTabTapped: (index) {
          setState(() {
            selectedNavIndex = index;
          });
          Navigator.pushReplacementNamed(context, ['/','/reminder','/doctors','/recommendation','/profile','/settings'][index]);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi, Welcome Back", style: TextStyle(color: Colors.blue)),
                        Text("John Doe", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/reminder');
                  },
                  child: Icon(Icons.notifications, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(weekDays.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: index == selectedDayIndex ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text("${weekDays[index].day}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(DateFormat('EEE').format(weekDays[index]).toUpperCase()),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reminders for ${DateFormat('EEEE').format(weekDays[selectedDayIndex])}",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Column(
                    children: getRemindersForSelectedDay().map((reminder) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(reminder['name']),
                          subtitle: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(reminder['time']))),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Services For You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/doctors'),
                    child: ServiceCard(
                      image: 'assets/doctor.jpg',
                      label: 'Doctors',
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/recommendation'),
                    child: ServiceCard(
                      image: 'assets/recommendation.png',
                      label: 'Recommendation',
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/reminder'),
                    child: ServiceCard(
                      image: 'assets/reminder.png',
                      label: 'Reminder',
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/corneal-exam'),
                    child: ServiceCard(
                      image: 'assets/eye_scan.jpg',
                      label: 'Corneal examination',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String image;
  final String label;

  const ServiceCard({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}