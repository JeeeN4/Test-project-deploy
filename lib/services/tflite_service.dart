import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  late Interpreter _interpreter;
  bool _isInitialized = false;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('model.tflite');
      _isInitialized = true;
      print('✅ Model berhasil dimuat');
    } catch (e) {
      print('❌ Gagal memuat model: $e');
    }
  }

  bool get isInitialized => _isInitialized;

  Future<Map<String, dynamic>> runInference(File imageFile) async {
    if (!_isInitialized) throw Exception('Model belum dimuat');

    // 1️⃣ Baca & ubah ukuran
    final rawImage = img.decodeImage(await imageFile.readAsBytes());
    if (rawImage == null) throw Exception('Gagal membaca gambar');
    final resized = img.copyResize(rawImage, width: 640, height: 640);

    // 2️⃣ Buat input tensor
    final input = List.generate(
      1,
      (_) => List.generate(
        640,
        (_) => List.generate(
          640,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );

    for (int y = 0; y < 640; y++) {
      for (int x = 0; x < 640; x++) {
        final pixel = resized.getPixel(x, y); // Tipe: Pixel

        // Ambil nilai RGB dari Pixel object
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        input[0][y][x][0] = r / 255.0;
        input[0][y][x][1] = g / 255.0;
        input[0][y][x][2] = b / 255.0;
      }
    }

    // 3️⃣ Bentuk output
    var output = List.generate(1, (_) => List.generate(8400, (_) => List.filled(85, 0.0)));

    // 4️⃣ Jalankan inferensi
    _interpreter.run(input, output);

    return {"output": output};
  }
}
