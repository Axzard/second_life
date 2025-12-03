import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    final horizontalPadding = screenWidth * 0.037;
    final verticalPadding = screenWidth * 0.02;
    final fontSize = screenWidth * 0.036;
    final marginRight = screenWidth * 0.02;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        margin: EdgeInsets.only(right: marginRight),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF00775A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
