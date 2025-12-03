import 'package:get/get.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/products/favorite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteViewModel extends GetxController {
  var loading = false.obs;
  var favorites = <ProductModel>[].obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      loading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      final snap = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("favorites")
          .get();

      favorites.value = snap.docs
          .map((d) => ProductModel.fromMap(d.data()))
          .toList();

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final isFav = await FavoriteService.isFavorite(product.id);

    if (isFav) {
      await FavoriteService.removeFavorite(product.id);
    } else {
      await FavoriteService.addFavorite(product);
    }

    await loadFavorites();
  }
}
