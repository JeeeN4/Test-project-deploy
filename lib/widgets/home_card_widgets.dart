import 'package:flutter/material.dart';


class HomeCardWidgets extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;
  final String imagePath;
  final bool hasButton;
  final Color buttonColor;

  const HomeCardWidgets({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.buttonText = '',
    this.onPressed,
    this.hasButton = false,
    this.buttonColor = const Color(0xFF6B7B48),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🧾 Text Section (kiri)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1724),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                if (hasButton) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 🖼️ Image Section (kanan)
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Image.asset(
              imagePath,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
