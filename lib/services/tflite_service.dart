import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TFLiteService {
  late Interpreter _interpreter;
  List<String> _labels = [];

  /// Muat model YOLO dan label
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      _labels = await rootBundle
          .loadString('assets/labels.txt')
          .then((value) => value.split('\n').where((e) => e.isNotEmpty).toList());
      print("✅ Model YOLO & label berhasil dimuat");
      print("📋 Labels: $_labels");
    } catch (e) {
      print("❌ Gagal memuat model: $e");
    }
  }

  /// Jalankan YOLO + OCR MLKit
  Future<Map<String, String>> analyzeImage(String imagePath) async {
    final imageBytes = File(imagePath).readAsBytesSync();
    final decoded = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(decoded, width: 640, height: 640);

    // (1) Buat input YOLO
    var input = List.generate(1, (_) =>
        List.generate(640, (_) =>
            List.generate(640, (_) => List.filled(3, 0.0))));
    for (int y = 0; y < 640; y++) {
      for (int x = 0; x < 640; x++) {
        final pixel = resized.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }

    // (2) Jalankan YOLO inference
    var output = List.filled(1 * 12 * 8400, 0.0)
        .reshape([1, 12, 8400]);
    _interpreter.run(input, output);

    // (3) Ambil deteksi label "nutrition-fact" dengan confidence threshold lebih rendah
    Map<String, dynamic>? box;
    double bestConfidence = 0.0;
    
    for (int i = 0; i < 8400; i++) {
      double x = output[0][0][i];
      double y = output[0][1][i];
      double w = output[0][2][i];
      double h = output[0][3][i];
      double conf = output[0][4][i];
      
      // Turunkan threshold untuk deteksi lebih sensitif
      if (conf > 0.25) {
        int cls = 0;
        double maxScore = 0;
        for (int j = 5; j < 12; j++) {
          if (output[0][j][i] > maxScore) {
            maxScore = output[0][j][i];
            cls = j - 5;
          }
        }

        if (cls < _labels.length) {
          String label = _labels[cls];
          print("🔍 Deteksi: $label (conf: ${conf.toStringAsFixed(2)}, class_score: ${maxScore.toStringAsFixed(2)})");
          
          // Cari label "nutrition-fact" dengan confidence tertinggi
          if (label.toLowerCase().contains("nutrition") && conf > bestConfidence) {
            bestConfidence = conf;
            box = {
              'x1': ((x - w / 2) * 640).clamp(0.0, 640.0),
              'y1': ((y - h / 2) * 640).clamp(0.0, 640.0),
              'x2': ((x + w / 2) * 640).clamp(0.0, 640.0),
              'y2': ((y + h / 2) * 640).clamp(0.0, 640.0),
            };
          }
        }
      }
    }

    if (box == null) {
      print("⚠️ Tidak ditemukan area Nutrition Facts, OCR dijalankan seluruh gambar.");
    } else {
      print("✅ Nutrition Facts ditemukan: ${box.toString()}");
    }

    // (4) Crop area Nutrition Facts
    final xMin = (box?['x1'] ?? 0.0).toInt();
    final yMin = (box?['y1'] ?? 0.0).toInt();
    final xMax = (box?['x2'] ?? 640.0).toInt();
    final yMax = (box?['y2'] ?? 640.0).toInt();

    final cropWidth = (xMax - xMin).clamp(1, resized.width);
    final cropHeight = (yMax - yMin).clamp(1, resized.height);

    final cropped = img.copyCrop(
      resized,
      x: xMin,
      y: yMin,
      width: cropWidth,
      height: cropHeight,
    );

    final tempPath = '${Directory.systemTemp.path}/cropped.png';
    File(tempPath).writeAsBytesSync(img.encodePng(cropped));

    // (5) Gunakan Google MLKit untuk OCR
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(tempPath);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final rawText = recognizedText.text;
    print("📄 Hasil OCR MLKit:\n$rawText");

    // (6) Ekstrak nilai nutrisi dengan regex yang lebih robust
    final result = {
      "gula": _extractValue(rawText, ["gula", "sugar"]),
      "garam": _extractValue(rawText, ["garam", "natrium", "sodium", "salt"]),
      "lemak": _extractValue(rawText, ["lemak", "fat", "lemak total"]),
      "protein": _extractValue(rawText, ["protein"]),
      "kalori": _extractValue(rawText, ["kalori", "energi total", "energy", "kkal", "kcal"]),
      "karbo": _extractValue(rawText, ["karbohidrat", "karbo", "carbohydrate"]),
      "serat": _extractValue(rawText, ["serat", "fiber", "serat pangan"]),
    };

    return result;
  }

  /// Ambil angka setelah keyword dengan multiple variations
  String _extractValue(String text, List<String> keywords) {
    for (String keyword in keywords) {
      // Cari pola: keyword diikuti angka (dengan berbagai format)
      final patterns = [
        RegExp("$keyword[\\s:]*([0-9]+[.,]?[0-9]*)", caseSensitive: false),
        RegExp("$keyword[\\s:]*\\n?[\\s]*([0-9]+[.,]?[0-9]*)", caseSensitive: false),
      ];
      
      for (var pattern in patterns) {
        final match = pattern.firstMatch(text);
        if (match != null && match.group(1) != null) {
          String value = match.group(1)!.replaceAll(',', '.');
          print("✅ Ekstrak $keyword: $value");
          return value;
        }
      }
    }
    return "0";
  }
}