import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String uid;
  final double gula;
  final double garam;
  final double lemak;
  final double protein;
  final double serat;
  final double kalori;
  final double karbo;
  final String nutriGrade; // A, B, C, D, E
  final String imageUrl;
  final DateTime scanDate; 

  Product({
    required this.uid,
    required this.gula,
    required this.garam,
    required this.lemak,
    required this.protein,
    required this.serat,
    required this.kalori,
    required this.karbo,
    required this.nutriGrade,
    required this.imageUrl,
    required this.scanDate, 
  });

 
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'gula': gula,
      'garam': garam,
      'lemak': lemak,
      'protein': protein,
      'serat': serat,
      'kalori': kalori,
      'karbo': karbo,
      'nutriGrade': nutriGrade,
      'imageUrl': imageUrl,
      'scanDate': Timestamp.fromDate(scanDate), 
    };
  }


  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      uid: map['uid'] ?? '',
      gula: (map['gula'] ?? 0).toDouble(),
      garam: (map['garam'] ?? 0).toDouble(),
      lemak: (map['lemak'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      serat: (map['serat'] ?? 0).toDouble(),
      kalori: (map['kalori'] ?? 0).toDouble(),
      karbo: (map['karbo'] ?? 0).toDouble(),
      nutriGrade: map['nutriGrade'] ?? 'C',
      imageUrl: map['imageUrl'] ?? '',
      scanDate: map['scanDate'] is Timestamp
        ? (map['scanDate'] as Timestamp).toDate()
        : DateTime.tryParse(map['scanDate'] ?? '') ?? DateTime.now(),
    );
  }
}
