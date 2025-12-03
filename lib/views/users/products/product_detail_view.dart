import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/viewmodels/users/products/product_detail_viewmodel.dart';
import 'package:second_life/widgets/users/product_details/product_action_buttons.dart';
import 'package:second_life/widgets/users/product_details/product_description.dart';
import 'package:second_life/widgets/users/product_details/product_image_slider.dart';
import 'package:second_life/widgets/users/product_details/product_seller_info.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // BUG FIX: Delete previous instance dan create new one untuk setiap product
    Get.delete<ProductDetailViewModel>();
    final vm = Get.put(ProductDetailViewModel(product));
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Obx(() => IconButton(
            onPressed: vm.toggleFavorite,
            icon: Icon(
              vm.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: vm.isFavorite.value ? Colors.red : Colors.grey,
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (vm.loading.value) {
          return _buildSkeletonDetail();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageSlider(images: vm.images),
                    ProductDescription(product: product),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: ProductSellerInfo(sellerId: product.userId),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            Obx(() => ProductActionButtons(
              product: product,
              sellerName: vm.seller.value?['name'] ?? 'Unknown',
            )),
          ],
        );
      }),
    );
  }

  Widget _buildSkeletonDetail() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone.square(
              size: 300,
              borderRadius: BorderRadius.zero,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.text(words: 3, fontSize: 24),
                  const SizedBox(height: 8),
                  Bone.text(words: 2, fontSize: 20),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Bone.button(width: 100, height: 32),
                      const SizedBox(width: 8),
                      Bone.button(width: 80, height: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Bone.text(words: 20),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Bone.text(words: 2),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Bone.circle(size: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Bone.text(words: 2),
                            Bone.text(words: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
