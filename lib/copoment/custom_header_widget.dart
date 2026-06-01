import 'package:flutter/material.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String imagePath;
  final String logoPath;
  final String title;
  final String subtitle;
  final double opacity;

  CustomHeaderWidget({
    required this.imagePath,  // Đường dẫn đến ảnh nền
    required this.logoPath,   // Đường dẫn đến logo
    required this.title,      // Tiêu đề
    required this.subtitle,   // Phụ đề
    this.opacity = 0.6,       // Mức độ opacity của lớp phủ
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Ảnh nền
        Image.asset(imagePath, width: double.infinity, height: 250, fit: BoxFit.cover),

        // Lớp phủ với độ mờ (opacity)
        Opacity(
          opacity: opacity,
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.deepPurpleAccent,
          ),
        ),

        // Nội dung nằm trên ảnh nền
        Positioned(
          left: 80,
          top: 10,
          child: Column(
            children: [
              Image.asset(
                logoPath, // Đường dẫn đến logo
                width: 160,
                height: 160,
              ),
              Text(
                title, // Tiêu đề
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle, // Phụ đề
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
