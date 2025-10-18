import 'package:flutter/material.dart';
import 'package:project_capstone_1/screen/edit_profile_screen.dart';
import 'package:project_capstone_1/widgets/form_widgets.dart';

import 'package:project_capstone_1/widgets/navbar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // DUMMY DATA
  final String _name = "Anna";
  final String _gender = "Perempuan";
  final DateTime _birthDate = DateTime(2002, 8, 15);
  final String _height = "160";
  final String _weight = "50";
  final String _activity = "Sedang";
  final String _email = "anna@email.com";

  // Fungsi untuk hitung usia
  int getAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE19D),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1724),
                ),
              ),
              const SizedBox(height: 30),

              
              ProfileField(label: "Nama", value:  _name),


              ProfileField(label: "Jenis Kelamin", value:  _gender),

      
              ProfileField(label: "Usia", value: "${getAge(_birthDate)} tahun"),

              
              ProfileField(label: "Tinggi (cm)", value:  _height),

              
              ProfileField(label: "Berat (kg)", value:  _weight),

            
              ProfileField(label: "Aktivitas Harian", value:  _activity),

              
              ProfileField( label: "Email", value:  _email),

              const SizedBox(height: 30),

              // EDIT BUTTON
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigasi ke Edit Profile Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7B48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 40),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),

              // LOGOUT BUTTON
              ElevatedButton(
                onPressed: () {
                  // TODO: Logout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(239, 83, 80, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 40),
                ),
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
