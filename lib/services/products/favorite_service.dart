import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:second_life/models/products/product_model.dart';

class FavoriteService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Tambah produk ke favorite user
  static Future<void> addFavorite(ProductModel product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(product.id);

    await docRef.set(product.toMap());
  }

  /// Hapus produk dari favorit
  static Future<void> removeFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(productId);

    await docRef.delete();
  }

  /// Cek apakah produk sudah difavoritkan
  static Future<bool> isFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(productId)
        .get();

    return doc.exists;
  }
}
