import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

 
  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();

   
    await FirebaseFirestore.instance
        .collection('products')
        .add(product.toMap());
  }

  Future<void> deleteProduct(String docId) async {
    // Hapus di Firestore berdasarkan ID dokumen
    await FirebaseFirestore.instance
        .collection('products')
        .doc(docId)
        .delete();

   
    _products.removeWhere((p) => p.uid == docId);
    notifyListeners();
  }

  
  Future<void> fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    final data =
        snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();

    _products
      ..clear()
      ..addAll(data);

    notifyListeners();
  }

  
  Future<void> fetchProductsByUser(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('uid', isEqualTo: uid)
        .get();

    final data =
        snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();

    _products
      ..clear()
      ..addAll(data);

    notifyListeners();
  }
}
