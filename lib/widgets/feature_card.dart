import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const FeatureCard({
    Key? key,
    required this.name,
    required this.icon,
    required this.color,
  }) : super(key: key);

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
        child: Icon(
          icon,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
