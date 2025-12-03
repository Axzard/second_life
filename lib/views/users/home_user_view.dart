import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:second_life/viewmodels/users/home_user_viewmodel.dart';
import 'package:second_life/views/users/chats/chat_list_view.dart';
import 'package:second_life/views/users/favorite_view.dart';
import 'package:second_life/views/users/products/jual_barang_view.dart';
import 'package:second_life/views/users/profile/profile_view.dart';
import 'package:second_life/widgets/users/category_chip.dart';
import 'package:second_life/widgets/users/products/product_card.dart';

class HomeUserView extends StatelessWidget {
  const HomeUserView({super.key});

  Widget _buildSkeletonProductCard() {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.square(
            size: 180,
            borderRadius: BorderRadius.circular(12),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 2),
                const SizedBox(height: 4),
                Bone.text(words: 1),
                const SizedBox(height: 4),
                Bone.text(words: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(HomeUserViewModel());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final horizontalPadding = screenWidth * 0.04;
    final searchFieldHeight = screenHeight * 0.06;
    final categoryHeight = screenHeight * 0.05;
    
    // Determine grid columns based on screen width
    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 3;
    }
    if (screenWidth > 900) {
      crossAxisCount = 4;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: const Icon(Icons.autorenew, size: 40, color: Colors.white),
        elevation: 0,
        backgroundColor: const Color(0xFF00775A),
        title: const Text(
          "Second Life",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: SizedBox(
              height: searchFieldHeight,
              child: TextField(
                onChanged: (value) => vm.searchProduct(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Cari produk...",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          
          // Category Header & Sort
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Text(
                  "Kategori",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Obx(() => DropdownButton<int>(
                  value: vm.sortType.value,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Terbaru")),
                    DropdownMenuItem(value: 2, child: Text("Termurah")),
                    DropdownMenuItem(value: 3, child: Text("Termahal")),
                  ],
                  onChanged: (val) {
                    if (val != null) vm.changeSort(val);
                  },
                )),
              ],
            ),
          ),
          
          SizedBox(height: screenHeight * 0.01),
          
          // Category Chips
          Obx(() => SizedBox(
            height: categoryHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vm.categoryList.length,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemBuilder: (context, index) {
                return Obx(() => CategoryChip(
                  title: vm.categoryList[index],
                  active: vm.selectedCategory.value == index,
                  onTap: () => vm.selectCategory(index),
                ));
              },
            ),
          )),
          
          SizedBox(height: screenHeight * 0.015),
          
          // Products Grid
          Expanded(
            child: Obx(() {
              if (vm.loading.value) {
                return Skeletonizer(
                  enabled: true,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenHeight * 0.015,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildSkeletonProductCard(),
                  ),
                );
              }

              if (vm.filteredProducts.isEmpty) {
                return const Center(
                  child: Text("Tidak ada produk"),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: screenHeight * 0.02,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenHeight * 0.015,
                ),
                itemCount: vm.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = vm.filteredProducts[index];
                  return ProductCard(
                    product: product,
                    userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: _buildNavItem(Icons.home, "Home", true, () {}, screenWidth),
              ),
              Flexible(
                child: _buildNavItem(Icons.favorite_border, "Favorit", false, () {
                  Get.to(() => const FavoriteView());
                }, screenWidth),
              ),
              Flexible(
                child: _buildNavItem(Icons.add_circle_outline, "Jual", false, () {
                  Get.to(() => const JualBarangView());
                }, screenWidth),
              ),
              Flexible(
                child: _buildNavItem(Icons.chat_bubble_outline, "Chat", false, () {
                  Get.to(() => const ChatListView());
                }, screenWidth),
              ),
              Flexible(
                child: _buildNavItem(Icons.person_outline, "Profil", false, () {
                  Get.to(() => const ProfileView());
                }, screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap, double screenWidth) {
    final iconSize = screenWidth * 0.07;
    final fontSize = screenWidth * 0.03;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF00775A) : Colors.grey,
            size: iconSize,
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: isActive ? const Color(0xFF00775A) : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
