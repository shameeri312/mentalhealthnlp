import "package:flutter/material.dart";

class EmotionFace extends StatelessWidget {
  final IconData emotionIcon;

  const EmotionFace({Key? key, required this.emotionIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Center(child: Icon(emotionIcon, size: 36, color: Colors.white)),
    );
  }
}
