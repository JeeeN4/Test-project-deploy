import 'package:flutter/material.dart';
import 'package:project_capstone_1/screen/login_screen.dart';
import 'package:project_capstone_1/widgets/form_widgets.dart';





class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  String? _gender;
  String? _activity;

  DateTime? _birthDate;

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE19D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Center(
                    child: Image.asset(
                      'images/illustrations/Create-Account-4-Streamline-Milano.png',
                      height: 190, 
                      fit: BoxFit.contain,
                    ),
                  ),

                const SizedBox(height: 40),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1724),
                  ),
                ),
                const SizedBox(height: 40),


                // NAMA
                CustomTextField(
                  hint:"Nama", 
                  controller:  _nameController),

                // JENIS KELAMIN (DROPDOWN)
                CustomDropdownField(
                  hint: "Jenis Kelamin",
                  value: _gender,
                  items: const ["Laki-laki", "Perempuan"],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),

                // TANGGAL LAHIR
                CustomDatePickerField(
                  hint: "Tanggal Lahir",
                  selectedDate: _birthDate,
                  onDateSelected: (picked) {
                    setState(() {
                      _birthDate = picked;
                    });
                  },
                ),

                // TINGGI
                CustomTextField(
                  hint: "Tinggi (cm)", 
                  controller:  _heightController,
                    keyboardType: TextInputType.number),

                // BERAT
                CustomTextField(
                  hint: "Berat (kg)",
                  controller:  _weightController,
                    keyboardType: TextInputType.number),

                // AKTIVITAS HARIAN (DROPDOWN)
                CustomDropdownFieldDetailed(
                  hint: "Aktivitas Harian",
                  value: _activity,
                  items: const [
                    {"value": "Sedentari", "label": "Sedentari (minim aktivitas)"},
                    {"value": "Ringan", "label": "Ringan (olahraga 1–2 kali/minggu)"},
                    {"value": "Sedang", "label": "Sedang (olahraga 3–5 kali/minggu)"},
                    {"value": "Berat", "label": "Berat (olahraga 6–7 kali/minggu)"},
                    {"value": "Sangat Berat", "label": "Sangat Berat (olahraga intens 2 kali sehari)"},
                  ],
                  onChanged: (value) {
                    setState(() {
                      _activity = value;
                    });
                  },
                ),

                // EMAIL
                CustomTextField(
                  hint: "Email",
                  controller:  _emailController,
                    keyboardType: TextInputType.emailAddress),

                // PASSWORD
                CustomTextField(
                  hint: "Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // SIGN UP BUTTON
                SizedBox(
                  //width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Nama: ${_nameController.text}");
                        debugPrint("Gender: $_gender");
                        debugPrint("BirthDate: $_birthDate");
                        debugPrint("Tinggi: ${_heightController.text}");
                        debugPrint("Berat: ${_weightController.text}");
                        debugPrint("Aktivitas: $_activity");
                        debugPrint("Email: ${_emailController.text}");

                        // TODO: sign up logic
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7B48),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

              
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible(child: Divider(thickness: 1)),
                      Text("Or connect with"),
                      Flexible(child: Divider(thickness: 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // GOOGLE BUTTON
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.g_mobiledata, size: 40),
                ),
                const SizedBox(height: 20),


                // LOGIN
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




}