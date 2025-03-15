import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final Color color;

  const FeatureCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 60,
        ),
      ),
    );
  }
}
