import 'package:get/get.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/favorite_service.dart';
import 'package:second_life/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailViewModel extends GetxController {
  final ProductModel product;

  var loading = true.obs;
  var seller = Rxn<Map<String, dynamic>>();
  var isFavorite = false.obs;
  late List<String> images;

  final UserService _userService = UserService();

  ProductDetailViewModel(this.product) {
    loadDetail();
    checkFavorite();
  }

  Future<void> loadDetail() async {
    try {
      loading.value = true;

      images = product.images;

      final userData = await _userService.getUserById(product.userId);

      int soldCount = await _getSoldCount(product.userId);

      seller.value = {
        "name": userData?.namaLengkap ?? "Tidak diketahui",
        "join": userData?.bergabung ?? "-",
        "sold": soldCount,
        "location": product.lokasi,
        "email": userData?.email ?? "-",
        "status": userData?.status ?? "aktif",
      };

      loading.value = false;
    } catch (e) {
      seller.value = {
        "name": "Penjual tidak ditemukan",
        "join": "-",
        "sold": 0,
        "location": product.lokasi,
      };

      loading.value = false;
    }
  }

  Future<int> _getSoldCount(String sellerId) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection("products")
          .where("userId", isEqualTo: sellerId)
          .get();

      return snap.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> checkFavorite() async {
    isFavorite.value = await FavoriteService.isFavorite(product.id);
  }

  Future<void> toggleFavorite() async {
    if (isFavorite.value) {
      await FavoriteService.removeFavorite(product.id);
      isFavorite.value = false;
    } else {
      await FavoriteService.addFavorite(product);
      isFavorite.value = true;
    }
  }
}
