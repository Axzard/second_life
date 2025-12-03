import 'package:flutter/material.dart';
import 'package:second_life/models/products/product_model.dart';

class ProductDescription extends StatelessWidget {
  final ProductModel product;

  const ProductDescription({super.key, required this.product});

  // ====== FUNGSI TIME AGO ======
  String timeAgo(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return "${diff.inSeconds} detik lalu";
      if (diff.inMinutes < 60) return "${diff.inMinutes} menit lalu";
      if (diff.inHours < 24) return "${diff.inHours} jam lalu";
      if (diff.inDays < 7) return "${diff.inDays} hari lalu";
      if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} minggu lalu";
      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} bulan lalu";

      return "${(diff.inDays / 365).floor()} tahun lalu";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive sizing
    final padding = screenWidth * 0.04;
    final badgeFontSize = screenWidth * 0.036;
    final timeFontSize = screenWidth * 0.038;
    final titleFontSize = screenWidth * 0.052;
    final priceFontSize = screenWidth * 0.052;
    final locationFontSize = screenWidth * 0.036;
    final descriptionFontSize = screenWidth * 0.038;
    
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Badge kondisi
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00775A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.kondisi,
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.025),

              Text(
                timeAgo(product.createdAt),
                style: TextStyle(
                  fontSize: timeFontSize,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.012),
          
          Text(
            product.nama,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: screenHeight * 0.008),
          
          Text(
            "Rp. ${product.harga}",
            style: TextStyle(
              fontSize: priceFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00775A),
            ),
          ),

          SizedBox(height: screenHeight * 0.018),

          Row(
            children: [
              Icon(Icons.location_on, size: locationFontSize * 1.2),
              SizedBox(width: screenWidth * 0.01),
              Expanded(
                child: Text(
                  product.lokasi,
                  style: TextStyle(fontSize: locationFontSize),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.025),

          // ====== DESKRIPSI ======
          Text(
            "Deskripsi",
            style: TextStyle(
              fontSize: descriptionFontSize * 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenHeight * 0.012),

          Text(
            product.deskripsi,
            style: TextStyle(
              fontSize: descriptionFontSize,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
