import 'package:flutter/material.dart';

// Widget tùy chỉnh cho ElevatedButton với Icon
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed; // Hàm gọi khi nhấn nút
  final String label;           // Text của nút
  final IconData icon;          // Icon của nút
  final Color color;            // Màu của nút

  CustomElevatedButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      ),
    );
  }
}
