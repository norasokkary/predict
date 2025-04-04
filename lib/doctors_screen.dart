import 'package:flutter/material.dart';
import 'doctor_info_screen.dart';

class DoctorsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Alexander Bennett, Ph.D.",
      "specialty": "Dermato-Genetics",
      "image": "assets/doctor1.png",
      "experience": "15 years",
      "focus": "Focus: The impact of hormonal imbalances on skin conditions."
    },
    {
      "name": "Dr. Michael Davidson, M.D.",
      "specialty": "Solar Dermatology",
      "image": "assets/doctor2.png",
      "experience": "12 years",
      "focus": "Focus: Research on UV exposure effects on skin health."
    },
    {
      "name": "Dr. Olivia Turner, M.D.",
      "specialty": "Dermato-Endocrinology",
      "image": "assets/doctor3.png",
      "experience": "10 years",
      "focus": "Focus: Relationship between endocrine disorders and skin conditions."
    },
    {
      "name": "Dr. Sophia Martinez, Ph.D.",
      "specialty": "Cosmetic Bioengineering",
      "image": "assets/doctor4.png",
      "experience": "8 years",
      "focus": "Focus: Development of bioengineered cosmetic treatments."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorInfoScreen(doctor: doctor),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(doctor["image"]),
                      radius: 30,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor["name"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          doctor["specialty"],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}
