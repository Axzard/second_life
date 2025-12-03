import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class KelolaProductViewModel extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var searchQuery = "".obs;

  void updateSearch(String value) {
    searchQuery.value = value.toLowerCase();
  }

  Stream<List<Map<String, dynamic>>> getAllProducts() {
    return _db
        .collection("products")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> finalList = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userDoc = await _db.collection("users").doc(data["userId"]).get();
        final user = userDoc.data() ?? {};

        finalList.add({
          "id": doc.id,
          ...data,
          "sellerName": user["namaLengkap"] ?? "Tidak diketahui",
        });
      }

      if (searchQuery.value.isNotEmpty) {
        finalList = finalList.where((item) {
          final name = item["nama"].toString().toLowerCase();
          final harga = item["harga"].toString().toLowerCase();
          final kategori = item["kategori"].toString().toLowerCase();
          final kondisi = item["kondisi"].toString().toLowerCase();
          final seller = item["sellerName"].toString().toLowerCase();

          return name.contains(searchQuery.value) ||
              harga.contains(searchQuery.value) ||
              kategori.contains(searchQuery.value) ||
              kondisi.contains(searchQuery.value) ||
              seller.contains(searchQuery.value);
        }).toList();
      }

      return finalList;
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection("products").doc(productId).delete();
  }
}
