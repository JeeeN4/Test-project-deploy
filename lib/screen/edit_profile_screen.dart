import 'package:flutter/material.dart';
import 'package:project_capstone_1/widgets/form_widgets.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // DUMMY DATA
  final TextEditingController _nameController = TextEditingController(text: "Anna");
  final TextEditingController _heightController = TextEditingController(text: "160");
  final TextEditingController _weightController = TextEditingController(text: "50");
  final TextEditingController _emailController = TextEditingController(text: "anna@email.com");
  final TextEditingController _passwordController = TextEditingController(text: "123456");
  
  String? _gender = "Perempuan";
  DateTime? _birthDate = DateTime(2002, 8, 15);
  String? _activity = "Sedang";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE19D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Center(
                  child: Image.asset(
                    'images/illustrations/Reset-Password-3-Streamline-Milano.png',
                    height: 200, 
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),
                
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1724),
                  ),
                ),
                const SizedBox(height: 30),

                // NAMA
                CustomTextField(hint: "Nama", controller: _nameController),

                // JENIS KELAMIN
                CustomDropdownField(
                  hint: "Jenis Kelamin",
                  value: _gender,
                  items: const ["Laki-laki", "Perempuan"],
                  onChanged: (val) => setState(() => _gender = val),
                ),

                // TANGGAL LAHIR
                CustomDatePickerField(
                  hint: "Tanggal Lahir",
                  selectedDate: _birthDate,
                  onDateSelected: (date) => setState(() => _birthDate = date),
                ),

                // TINGGI DAN BERAT
                CustomTextField(
                  hint: "Tinggi (cm)",
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  hint: "Berat (kg)",
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                ),

                // AKTIVITAS HARIAN
                CustomDropdownField(
                  hint: "Aktivitas Harian",
                  value: _activity,
                  items: const [
                    "Sedentari",
                    "Ringan",
                    "Sedang",
                    "Berat",
                    "Sangat Berat"
                  ],
                  onChanged: (val) => setState(() => _activity = val),
                ),

                // EMAIL
                CustomTextField(
                  hint: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                // PASSWORD
                CustomTextField(
                  hint: "Password",
                  controller: _passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                // SAVE BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Data diperbarui!");
                        // TODO: logic save profile
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7B48),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CANCEL BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // kembali ke Profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
