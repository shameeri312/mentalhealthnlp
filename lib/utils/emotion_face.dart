import "package:flutter/material.dart";

class EmotionFace extends StatelessWidget {
  final String EmotionIcon;

  const EmotionFace({Key? key, required this.EmotionIcon}) : super(key: key);

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
      child: Center(child: Text(EmotionIcon, style: TextStyle(fontSize: 28))),
    );
  }
}
