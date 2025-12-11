import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_life/models/auth/user_model.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    "users",
  );

  // SIMPAN USER BARU
  Future<void> saveUserData(UserModel user) async {
    await users.doc(user.uid).set(user.toMap());
  }

  // GET DATA USER
  Future<UserModel?> getUserById(String uid) async {
    final doc = await users.doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // 🔥 AMBIL SEMUA USER (untuk Kelola User)
  Stream<List<UserModel>> getAllUsers() {
    return users.snapshots().map((snap) {
      return snap.docs.map((d) {
        return UserModel.fromMap(d.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<List<UserModel>> getAllUsersOnce() async {
    final query = await users.get();

    return query.docs
        .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}
