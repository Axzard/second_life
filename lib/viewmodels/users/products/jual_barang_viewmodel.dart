import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/products/jual_barang_service.dart';
import 'package:second_life/utils/image_converter.dart';

class JualBarangViewModel extends GetxController {
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final lokasiC = TextEditingController();
  final deskripsiC = TextEditingController();

  var selectedKategori = Rxn<String>();
  var selectedKondisi = Rxn<String>();
  var kategoriList = <String>[].obs;
  var kondisiList = [
    "Baru",
    "Seperti Baru",
    "Bekas - Baik",
    "Bekas - Cukup Baik",
  ].obs;

  final ImagePicker picker = ImagePicker();
  var images = <File>[].obs;
  final JualBarangService _service = JualBarangService();

  var isLoading = false.obs;
  var categoryLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategory();
  }

  Future<void> loadCategory() async {
    categoryLoading.value = true;

    try {
      kategoriList.value = await _service.getCategory();
    } catch (e) {
      kategoriList.value = [];
    }

    categoryLoading.value = false;
  }

  Future<void> pickImages() async {
    try {
      final pickedList = await picker.pickMultiImage(imageQuality: 75);

      for (var p in pickedList) {
        if (images.length >= 5) break;
        images.add(File(p.path));
      }
    } catch (e) {
      // Error picking images
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

  void setKategori(String? val) {
    selectedKategori.value = val;
  }

  void setKondisi(String? val) {
    selectedKondisi.value = val;
  }

  bool _isValidForm() {
    return namaC.text.trim().isNotEmpty &&
        selectedKategori.value != null &&
        selectedKondisi.value != null &&
        hargaC.text.trim().isNotEmpty &&
        lokasiC.text.trim().isNotEmpty &&
        deskripsiC.text.trim().isNotEmpty &&
        images.isNotEmpty;
  }

  Future<void> postProduct() async {
    if (!_isValidForm()) {
      Get.snackbar(
        "Error",
        "Lengkapi semua field dan tambahkan minimal 1 foto",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      List<String> base64Images = [];
      for (var img in images) {
        final b = await ImageConverter.fileToBase64(img);
        base64Images.add(b);
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User belum login");

      final productId = DateTime.now().millisecondsSinceEpoch.toString();

      final model = ProductModel(
        id: productId,
        userId: user.uid,
        nama: namaC.text.trim(),
        kategori: selectedKategori.value!,
        kondisi: selectedKondisi.value!,
        harga: hargaC.text.trim(),
        lokasi: lokasiC.text.trim(),
        deskripsi: deskripsiC.text.trim(),
        images: base64Images,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _service.postProduct(model);

      isLoading.value = false;

      Get.snackbar(
        "Success",
        "Produk berhasil diposting!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00775A),
        colorText: Colors.white,
      );

      _resetForm();
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetForm() {
    namaC.clear();
    hargaC.clear();
    lokasiC.clear();
    deskripsiC.clear();
    selectedKategori.value = null;
    selectedKondisi.value = null;
    images.clear();
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    lokasiC.dispose();
    deskripsiC.dispose();
    super.onClose();
  }
}
