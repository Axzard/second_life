import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_life/models/products/category_model.dart';

class CategoryService {
  final _category = FirebaseFirestore.instance.collection('category');

  // Tambah kategori (kembalikan true jika berhasil)
  Future<bool> addCategory(String name) async {
    try {
      await _category.add({'name': name});
      return true;
    } catch (e) {
            return false;
    }
  }

  // Update kategori
  Future<bool> updateCategory(String id, String name) async {
    try {
      await _category.doc(id).update({'name': name});
      return true;
    } catch (e) {
            return false;
    }
  }

  // Hapus kategori
  Future<bool> deleteCategory(String id) async {
    try {
      await _category.doc(id).delete();
      return true;
    } catch (e) {
            return false;
    }
  }

  // Ambil semua kategori
  Future<List<CategoryModel>> getCategory() async {
    final snapshot = await _category.get();
    return snapshot.docs
        .map((e) => CategoryModel.fromMap(e.data(), e.id))
        .toList();
  }

  // Hitung total produk berdasar nama kategori (ambil dari collection 'products')
  Future<int> getTotalProduct(String categoryName) async {
    try {
      final productCollection = FirebaseFirestore.instance.collection('products');
      final snap = await productCollection
          .where('category', isEqualTo: categoryName)
          .get();
      return snap.docs.length;
    } catch (e) {
            return 0;
    }
  }
}
