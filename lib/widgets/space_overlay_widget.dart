import 'package:flutter/material.dart';

class SpaceOverlay extends StatelessWidget {
  final double x;
  final double y;
  final Color color;
  final VoidCallback onTap;
  final bool isSquare; 

  
  const SpaceOverlay({
    super.key,
    required this.x,
    required this.y,
    required this.color,
    required this.onTap,
    this.isSquare = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle, 
            color: color,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}