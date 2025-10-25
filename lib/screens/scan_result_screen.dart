import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ScanResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic>? inferenceResult; // hasil dari OCR/YOLO

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    this.inferenceResult,
  });

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
      default:
        return Colors.grey;
    }
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
      default:
        return 'images/nutri_grade_labels/B-nutri-grade.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mapping hasil OCR ke nilai gizi, parsing aman ke double
    final pred = inferenceResult ?? {};
    double parseOrZero(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final product = Product(
      uid: FirebaseAuth.instance.currentUser?.uid ?? "guest",
      gula: parseOrZero(pred["gula"]),
      garam: parseOrZero(pred["garam"]),
      lemak: parseOrZero(pred["lemak"]),
      protein: parseOrZero(pred["protein"]),
      serat: parseOrZero(pred["serat"]),
      kalori: parseOrZero(pred["kalori"]),
      karbo: parseOrZero(pred["karbo"]),
      nutriGrade: pred["nutriGrade"] ?? "B",
      imageUrl: imagePath,
      scanDate: DateTime.now(),
    );

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final bgColor = _getBackgroundColor(product.nutriGrade);
    final nutriImage = _getNutriGradeImage(product.nutriGrade);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'HASIL SCAN',
          style: TextStyle(color: Colors.white, letterSpacing: 1.2),
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
                    child: File(imagePath).existsSync()
                        ? Image.file(
                            File(imagePath),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            imagePath,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    nutriImage,
                    height: 40,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.scanDate.toString(),
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
                  _buildNutritionRow("Gula", product.gula),
                  _buildNutritionRow("Garam", product.garam),
                  _buildNutritionRow("Lemak jenuh", product.lemak),
                  _buildNutritionRow("Protein", product.protein),
                  _buildNutritionRow("Kalori", product.kalori),
                  _buildNutritionRow("Karbo", product.karbo),
                  _buildNutritionRow("Serat", product.serat),
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
                          await productProvider.addProduct(product);
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
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
