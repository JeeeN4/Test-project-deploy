import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ScanResultScreen extends StatelessWidget {
  final String imagePath;

  const ScanResultScreen({super.key, required this.imagePath});

  
  Color _getBackgroundColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color.fromARGB(255, 44, 87, 45);
      case 'B':
        return const Color.fromARGB(255, 147, 202, 142); 
      case 'C':
        return Colors.orange.shade200; 
      case 'D':
        return const Color.fromARGB(255, 160, 71, 71); 
    }
    throw ArgumentError('Invalid grade value: $grade');
  }

  
  String _getNutriGradeImage(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return 'images/nutri_grade_labels/A-nutri-grade.png';
      case 'B':
        return 'images/nutri_grade_labels/B-nutri-grade.png';
      case 'C':
        return 'images/nutri_grade_labels/C-nutri-grade.png';
      case 'D':
        return 'images/nutri_grade_labels/D-nutri-grade.png';
    }
    throw ArgumentError('Invalid grade value: $grade');
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data hasil scan
    final dummyProduct = Product(
      uid: FirebaseAuth.instance.currentUser!.uid,
      gula: 20,
      garam: 10,
      lemak: 5,
      protein: 14,
      serat: 0,
      kalori: 270,
      karbo: 0,
      nutriGrade: "B",
      imageUrl: imagePath,
      scanDate: DateTime.now(),
    );

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

   
    final bgColor = _getBackgroundColor(dummyProduct.nutriGrade);
    final nutriImage = _getNutriGradeImage(dummyProduct.nutriGrade);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'HASIL SCAN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      dummyProduct.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    nutriImage, 
                    height: 40,
                    alignment: AlignmentGeometry.centerLeft,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dummyProduct.scanDate.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Nutrition Facts",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionRow("Gula", dummyProduct.gula),
                  _buildNutritionRow("Garam", dummyProduct.garam),
                  _buildNutritionRow("Lemak jenuh", dummyProduct.lemak),
                  _buildNutritionRow("Protein", dummyProduct.protein),
                  _buildNutritionRow("Kalori", dummyProduct.kalori),
                  _buildNutritionRow("Karbo", dummyProduct.karbo),
                  _buildNutritionRow("Serat", dummyProduct.serat),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Back"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await productProvider.addProduct(dummyProduct);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Produk berhasil ditambahkan!"),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Add"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}