import 'package:flutter/material.dart';

import 'package:project_capstone_1/widgets/navbar_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // DUMMY DATA
  final List<Map<String, dynamic>> productList = [
    {
      "image":
          "images/illustrations/nutrition-fact-dummy.png", 
      "date": "2025-10-13",
      "nutrition": "Gula, Protein, Lemak",
      "grade": "A"
    },
    {
      "image":
          "images/illustrations/nutrition-fact-dummy.png",
      "date": "2025-10-12",
      "nutrition": "Gula, Protein, Lemak",
      "grade": "D"
    },
    {
      "image":
          "images/illustrations/nutrition-fact-dummy.png",
      "date": "2025-10-11",
      "nutrition": "Gula, Lemak",
      "grade": "C"
    },
  ];


  Color getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case "A":
        return Colors.green;
      case "B":
        return Colors.lightGreen;
      case "C":
        return Colors.orange;
      case "D":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE19D),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Product List",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1724),
                ),
              ),
              const SizedBox(height: 20),

              // LIST PRODUK
              Expanded(
                child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          // GAMBAR PRODUK
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            ),
                            child: Image.network(
                              product["image"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // INFO PRODUK
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['date'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      // NUTRITION GRADE
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: getGradeColor(
                                            product["grade"] ?? "C"),
                                        child: Text(
                                          product["grade"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          product["nutrition"],
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          // TODO: fungsi delete firestore
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.check_circle,
                                            color: Colors.green),
                                        onPressed: () {
                                          // TODO: fungsi simpan ke todays food log (udah dikonsumsi)
                                        },
                                      ),
                                    ]
                                    
                                  ),
                                ],
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
