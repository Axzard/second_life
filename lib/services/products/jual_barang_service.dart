import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_life/models/products/product_model.dart';

class JualBarangService {
  final CollectionReference products = FirebaseFirestore.instance.collection(
    "products",
  );

  /// SIMPAN PRODUK KE FIRESTORE
  Future<void> postProduct(ProductModel model) async {
    await products.doc(model.id).set(model.toMap());
  }

  /// AMBIL SEMUA PRODUK DARI FIRESTORE
   /// STREAM PRODUK (REALTIME)
  Stream<List<ProductModel>> streamProducts() {
    return products.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// AMBIL KATEGORI DARI FIRESTORE
  Future<List<String>> getCategory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("category")
        .orderBy("name")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return data["name"].toString();
    }).toList();
  }
}
