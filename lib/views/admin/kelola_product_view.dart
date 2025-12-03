import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/admin/kelola_product_viewmodel.dart';

class KelolaProductView extends StatelessWidget {
  const KelolaProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(KelolaProductViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text("Kelola Produk", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => vm.updateSearch(val),
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: vm.getAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada produk"));
                }

                final products = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final images = product["images"] ?? [];
                    final firstImage = images.isNotEmpty ? images[0] : "";

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: firstImage.isNotEmpty
                            ? Image.memory(
                                const Base64Decoder().convert(firstImage),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image),
                              ),
                        title: Text(
                          product["nama"] ?? "No Name",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Harga: ${product["harga"] ?? "0"}"),
                            Text("Penjual: ${product["sellerName"] ?? "Unknown"}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Hapus Produk",
                              middleText: "Apakah Anda yakin ingin menghapus produk ini?",
                              textCancel: "Batal",
                              textConfirm: "Hapus",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                vm.deleteProduct(product["id"]);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

