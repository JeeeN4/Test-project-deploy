import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:project_capstone_1/screen/home_user_screen.dart';
import 'package:project_capstone_1/screen/home_guest_screen.dart';
import 'package:project_capstone_1/provider/auth_provider.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isLoggedIn
              ? const HomeUserScreen()
              : const HomeGuestScreen();
        },
      ),
    );
  }
}
















// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SadarGizi',
//       theme: ThemeData(),
//       home: const LoginScreen(),

      
//     );
//   }
// }

                                            