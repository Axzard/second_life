import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/users/profile_viewmodel.dart';

class ProfileEditDialog {
  static Future<void> show(
    ProfileViewModel vm,
    Map<String, dynamic> product,
  ) async {
    final nameController = TextEditingController(text: product["name"]);
    final priceController = TextEditingController(text: product["price"]);
    final deskripsiController = TextEditingController(text: product["deskripsi"] ?? "");
    
    // Normalize status - convert to proper case
    String rawStatus = product["status"] ?? "Tersedia";
    String status = rawStatus.toLowerCase() == "terjual" ? "Terjual" : "Tersedia";

    return Get.dialog(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Edit Produk"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Produk"),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: "Status"),
                  items: ["Tersedia", "Terjual"].map((s) {
                    return DropdownMenuItem(value: s, child: Text(s));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        status = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await vm.updateProduct(
                  productId: product["id"],
                  newName: nameController.text,
                  newPrice: priceController.text,
                  newStatus: status,
                  newdeskripsi: deskripsiController.text,
                );
                Get.back();
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
