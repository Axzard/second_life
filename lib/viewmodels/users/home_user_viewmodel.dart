import 'package:get/get.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/jual_barang_service.dart';

class HomeUserViewModel extends GetxController {
  final JualBarangService _service = JualBarangService();

  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var loading = true.obs;
  var selectedCategory = 0.obs;
  var categoryList = ["Semua"].obs;
  var sortType = 1.obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    listenProducts();
    loadCategories();
  }

  void listenProducts() {
    _service.streamProducts().listen((data) {
      products.value = data;
      applyFilters();
      loading.value = false;
    });
  }

  Future<void> loadCategories() async {
    try {
      List<String> categories = await _service.getCategory();
      categoryList.value = ["Semua", ...categories];
    } catch (e) {
      categoryList.value = ["Semua"];
    }
  }

  void selectCategory(int index) {
    selectedCategory.value = index;
    applyFilters();
  }

  void searchProduct(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    List<ProductModel> temp = List.from(products);

    if (selectedCategory.value != 0) {
      final kategoriDipilih = categoryList[selectedCategory.value];
      temp = temp.where((p) {
        return p.kategori.toLowerCase() == kategoriDipilih.toLowerCase();
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((p) {
        return p.nama.toLowerCase().contains(searchQuery.value) ||
            p.deskripsi.toLowerCase().contains(searchQuery.value);
      }).toList();
    }

    switch (sortType.value) {
      case 1:
        temp.sort((a, b) {
          DateTime dateA = DateTime.tryParse(a.createdAt) ?? DateTime(2000);
          DateTime dateB = DateTime.tryParse(b.createdAt) ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
        break;

      case 2:
        temp.sort((a, b) {
          int hargaA = int.tryParse(a.harga) ?? 0;
          int hargaB = int.tryParse(b.harga) ?? 0;
          return hargaA.compareTo(hargaB);
        });
        break;

      case 3:
        temp.sort((a, b) {
          int hargaA =
              int.tryParse(a.harga.replaceAll('.', '').replaceAll(',', '')) ??
              0;
          int hargaB =
              int.tryParse(b.harga.replaceAll('.', '').replaceAll(',', '')) ??
              0;
          return hargaB.compareTo(hargaA);
        });
        break;
    }

    filteredProducts.value = temp;
  }

  void changeSort(int value) {
    sortType.value = value;
    applyFilters();
  }
}
