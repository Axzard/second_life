import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:second_life/viewmodels/users/favorite_viewmodel.dart';
import 'package:second_life/widgets/users/products/product_card.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(FavoriteViewModel());
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine grid columns based on screen width
    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 3;
    }
    if (screenWidth > 900) {
      crossAxisCount = 4;
    }
    
    final horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text(
          "Favorit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (vm.loading.value) {
          return _buildSkeletonLoader(
            screenWidth: screenWidth,
            horizontalPadding: horizontalPadding,
            crossAxisCount: crossAxisCount,
          );
        }

        if (vm.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: screenWidth * 0.2,
                  color: Colors.grey,
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  "Belum ada produk favorit",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.68,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
          ),
          itemCount: vm.favorites.length,
          itemBuilder: (context, index) {
            final product = vm.favorites[index];
            return ProductCard(
              product: product,
              userId: FirebaseAuth.instance.currentUser?.uid ?? "",
              isFavoritePage: true,
            );
          },
        );
      }),
    );
  }

  Widget _buildSkeletonLoader({
    required double screenWidth,
    required double horizontalPadding,
    required int crossAxisCount,
  }) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.all(horizontalPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.68,
          crossAxisSpacing: screenWidth * 0.03,
          mainAxisSpacing: screenWidth * 0.03,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildSkeletonCard(screenWidth);
        },
      ),
    );
  }

  Widget _buildSkeletonCard(double screenWidth) {
    final badgeFontSize = screenWidth * 0.028;
    final categoryFontSize = screenWidth * 0.028;
    final nameFontSize = screenWidth * 0.036;
    final priceFontSize = screenWidth * 0.036;
    final locationFontSize = screenWidth * 0.03;

    return Container(
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
                  // Skeleton Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),

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
                        'Loading',
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
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.015),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: screenWidth * 0.05,
                      ),
                    ),
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
                    'Loading Category',
                    style: TextStyle(
                      fontSize: categoryFontSize,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Product Name
                  Text(
                    'Loading Product Name Here',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  // Price
                  Text(
                    'Rp 000.000',
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
                          'Loading Location',
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
    );
  }
}
