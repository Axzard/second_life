import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSellerInfo extends StatelessWidget {
  final String sellerId;

  const ProductSellerInfo({super.key, required this.sellerId});

  Future<Map<String, dynamic>> _getSellerData() async {
    if (sellerId.isEmpty) return {};

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .get();
    if (!userDoc.exists) return {};

    final userData = userDoc.data()!;

    final productSnap = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: sellerId)
        .get();

    final totalProduk = productSnap.docs.length;

    return {
      "namaLengkap": userData["namaLengkap"] ?? "Tidak diketahui",
      "bergabung": userData["bergabung"] ?? "-",
      "totalProduk": totalProduk,
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerPadding = screenWidth * 0.04;
    final avatarRadius = screenWidth * 0.075;
    final titleFontSize = screenWidth * 0.047;
    final nameFontSize = screenWidth * 0.042;
    final infoFontSize = screenWidth * 0.036;

    return FutureBuilder<Map<String, dynamic>>(
      future: _getSellerData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final seller = snapshot.data!;
        if (seller.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(containerPadding),
            child: Text(
              "Data penjual tidak tersedia",
              style: TextStyle(fontSize: infoFontSize),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          padding: EdgeInsets.all(containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Penjual",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: const Color.fromARGB(255, 193, 191, 191),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: avatarRadius * 1.2,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seller["namaLengkap"],
                          style: TextStyle(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.004),
                        Text(
                          "Bergabung sejak " + seller["bergabung"],
                          style: TextStyle(fontSize: infoFontSize),
                        ),
                        Text(
                          seller["totalProduk"].toString() + " Produk dijual",
                          style: TextStyle(fontSize: infoFontSize),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
