import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/models/products/category_model.dart';
import 'package:second_life/services/products/category_service.dart';

class KelolaKategoriViewModel extends GetxController {
  final CategoryService _service = CategoryService();

  var category = <CategoryModel>[].obs;
  var totalProducts = <String, int>{}.obs;
  var loading = true.obs;
  var actionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void showSnackBar(String message, Color color) {
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
    );
  }

  Future<void> loadData() async {
    loading.value = true;

    try {
      category.value = await _service.getCategory();
      totalProducts.clear();

      for (var cat in category) {
        int total = await _service.getTotalProduct(cat.name);
        totalProducts[cat.id] = total;
      }
    } catch (e) {
      // Error loading data
    }

    loading.value = false;
  }

  Future<void> addCategory(String name) async {
    actionLoading.value = true;

    final success = await _service.addCategory(name);

    actionLoading.value = false;

    if (success) {
      showSnackBar("Kategori berhasil ditambahkan", const Color(0xFF00775A));
      await loadData();
    } else {
      showSnackBar("Gagal menambahkan kategori", Colors.red);
    }
  }

  Future<void> updateCategory(String id, String newName) async {
    actionLoading.value = true;

    final success = await _service.updateCategory(id, newName);

    actionLoading.value = false;

    if (success) {
      showSnackBar("Kategori berhasil diupdate", const Color(0xFF00775A));
      await loadData();
    } else {
      showSnackBar("Gagal mengupdate kategori", Colors.red);
    }
  }

  void confirmEdit(String id, String oldName) {
    final TextEditingController nameC = TextEditingController(text: oldName);

    Get.defaultDialog(
      title: "Edit Kategori",
      content: TextField(
        controller: nameC,
        decoration: const InputDecoration(
          labelText: "Nama Kategori",
          border: OutlineInputBorder(),
        ),
      ),
      textCancel: "Batal",
      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final newName = nameC.text.trim();
        if (newName.isEmpty) return;

        await updateCategory(id, newName);
        Get.back();
      },
    );
  }

  Future<void> confirmDelete(String id, String name) async {
    Get.defaultDialog(
      title: "Hapus Kategori",
      middleText: "Yakin ingin menghapus kategori \"$name\" ?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await deleteCategory(id);
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    actionLoading.value = true;

    final success = await _service.deleteCategory(id);

    actionLoading.value = false;

    if (success) {
      showSnackBar("Kategori dihapus", Colors.red);
      await loadData();
    } else {
      showSnackBar("Gagal menghapus kategori", Colors.red);
    }
  }
}
