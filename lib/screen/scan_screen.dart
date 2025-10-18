import 'package:flutter/material.dart';
import '../widgets/navbar_widgets.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Scan")),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
    );
  }
}
