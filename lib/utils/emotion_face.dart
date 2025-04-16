import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
  final String imagePath;

  const EmotionFace({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Attempting to load image from: $imagePath'); // Debug print
    return Container(
      width: 70,
      height: 70,
      child: Image.asset(
        imagePath,
        width: 70,
        height: 70,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Image load error for $imagePath: $error'); // Error debug
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      ),
    );
  }
}
