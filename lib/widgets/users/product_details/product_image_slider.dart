import 'dart:convert';
import 'package:flutter/material.dart';

class ProductImageSlider extends StatelessWidget {
  final List<String> images;

  const ProductImageSlider({super.key, required this.images});

  bool _isBase64(String data) {
    return !(data.startsWith("http://") || data.startsWith("https://"));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.45;

    return SizedBox(
      height: imageHeight,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final img = images[index];
          return _buildImage(img);
        },
      ),
    );
  }

  Widget _buildImage(String img) {
    if (_isBase64(img)) {
      try {
        final bytes = base64Decode(img);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _errorPlaceholder(),
        );
      } catch (e) {
        return _errorPlaceholder();
      }
    }

    return Image.network(
      img,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _errorPlaceholder(),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }
}
