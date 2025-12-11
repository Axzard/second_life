import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/favorite_service.dart';
import 'package:second_life/views/users/products/product_detail_view.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String userId;
  final bool isFavoritePage;
  final VoidCallback? onHeartTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.userId,
    this.isFavoritePage = false,
    this.onHeartTap,
  });

  bool _isBase64(String data) {
    return !(data.startsWith("http://") || data.startsWith("https://"));
  }

  String? _primaryImage() {
    if (product.images.isEmpty) return null;
    return product.images.first;
  }

  /// Sanitize base64 string - remove invalid UTF8 characters
  String _sanitizeBase64(String input) {
    try {
      // Remove whitespace and newlines
      String cleaned = input.replaceAll(RegExp(r'\s+'), '');
      
      // Remove any non-base64 characters
      cleaned = cleaned.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
      
      // Ensure proper padding
      while (cleaned.length % 4 != 0) {
        cleaned += '=';
      }
      
      return cleaned;
    } catch (e) {
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = _primaryImage();
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    final badgeFontSize = screenWidth * 0.028;
    final categoryFontSize = screenWidth * 0.028;
    final nameFontSize = screenWidth * 0.036;
    final priceFontSize = screenWidth * 0.036;
    final locationFontSize = screenWidth * 0.03;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Badges
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  children: [
                    _buildImageWidget(primary),

                    // BADGE KONDISI
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00775A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.kondisi,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // FAVORITE BUTTON
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildFavoriteButton(screenWidth),
                    ),
                  ],
                ),
              ),
            ),

            // DETAIL PRODUK
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category
                    Text(
                      product.kategori,
                      style: TextStyle(
                        fontSize: categoryFontSize,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Product Name
                    Flexible(
                      child: Text(
                        product.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),

                    // Price
                    Text(
                      "Rp  ${product.harga}",
                      style: TextStyle(
                        fontSize: priceFontSize,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: locationFontSize * 1.2,
                          color: Colors.grey,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Expanded(
                          child: Text(
                            product.lokasi,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: locationFontSize,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FAVORITE BUTTON HANDLER
  Widget _buildFavoriteButton(double screenWidth) {
    final iconSize = screenWidth * 0.05;
    
    // Jika parent override aksi ? gunakan ini
    if (onHeartTap != null) {
      return GestureDetector(
        onTap: onHeartTap,
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.015),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: iconSize,
          ),
        ),
      );
    }

    // Jika dari halaman favorit ? icon selalu merah
    if (isFavoritePage) {
      return Container(
        padding: EdgeInsets.all(screenWidth * 0.015),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          color: Colors.red,
          size: iconSize,
        ),
      );
    }

    // Default: cek status favorite dari Firestore
    return FutureBuilder<bool>(
      future: FavoriteService.isFavorite(product.id),
      builder: (context, snapshot) {
        bool isFav = snapshot.data ?? false;

        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () async {
                if (isFav) {
                  await FavoriteService.removeFavorite(product.id);
                } else {
                  await FavoriteService.addFavorite(product);
                }
                setState(() => isFav = !isFav);
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.015),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                  size: iconSize,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageWidget(String? primary) {
    if (primary == null || primary.isEmpty) return _errorPlaceholder();

    if (_isBase64(primary)) {
      try {
        // Sanitize base64 string before decoding
        final sanitized = _sanitizeBase64(primary);
        final bytes = base64Decode(sanitized);
        
        return Image.memory(
          bytes,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _errorPlaceholder(),
        );
      } catch (e) {
        // Log error for debugging (optional)
        debugPrint('Base64 decode error: $e');
        return _errorPlaceholder();
      }
    }

    return Image.network(
      primary,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _errorPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
