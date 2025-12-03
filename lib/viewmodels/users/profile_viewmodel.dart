import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_life/services/auth/user_status_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second_life/views/auth/welcome_view.dart';
import 'package:second_life/models/auth/user_model.dart';


class ProfileViewModel extends GetxController {
  final UserStatusService _statusService = UserStatusService();
  
  var loading = true.obs;
  var selectedTab = 0.obs;
  var isSaving = false.obs;

  Rx<UserModel?> user = Rx<UserModel?>(null);
  var myProducts = <Map<String, dynamic>>[].obs;
  var soldProducts = <Map<String, dynamic>>[].obs;

  UserModel? get profile => user.value;
  String get bio => user.value?.bio ?? '';
  String? get userPhoto => user.value?.profilePhoto;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    loading.value = true;

    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        loading.value = false;
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(authUser.uid)
          .get();

      final data = userDoc.data() ?? {};

      user.value = UserModel.fromMap({
        "uid": data["uid"] ?? authUser.uid,
        "namaLengkap": data["namaLengkap"] ?? authUser.displayName ?? "",
        "email": data["email"] ?? authUser.email ?? "",
        "role": data["role"] ?? "user",
        "status": data["status"] ?? "aktif",
        "bergabung": data["bergabung"] ?? _formatTimestamp(data["createdAt"]),
        "profilePhoto": data["profilePhoto"],
        "bio": data["bio"],
      });

      final productSnap = await FirebaseFirestore.instance
          .collection("products")
          .where("userId", isEqualTo: authUser.uid)
          .get();

      myProducts.clear();
      soldProducts.clear();

      for (var doc in productSnap.docs) {
        final d = doc.data();
        final item = {
          "id": doc.id,
          "name": d["nama"] ?? d["title"] ?? "",
          "price": d["harga"] ?? d["price"] ?? "",
          "status": d["status"] ?? "Tersedia",
          "images": d["images"] ?? d["imageUrl"] ?? [],
          "deskripsi": d["deskripsi"] ?? "",
        };

        if (item["status"] == "Terjual") {
          soldProducts.add(item);
        } else {
          myProducts.add(item);
        }
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> editProfile(
    String newName,
    String newBio, {
    File? photoFile,
  }) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    isSaving.value = true;

    try {
      final Map<String, dynamic> updateData = {
        "namaLengkap": newName,
        "bio": newBio,
      };

      if (photoFile != null) {
        final bytes = await photoFile.readAsBytes();
        final base64String = base64Encode(bytes);
        updateData["profilePhoto"] = base64String;
      }

      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(authUser.uid);

      await docRef.update(updateData);

      await loadProfile();
    } catch (e) {
      isSaving.value = false;
      rethrow;
    }

    isSaving.value = false;
  }

  Future<void> updateProfilePhoto(String base64Photo) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    isSaving.value = true;

    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(authUser.uid);

      await docRef.update({"profilePhoto": base64Photo});

      await loadProfile();
    } catch (e) {
      isSaving.value = false;
      rethrow;
    }

    isSaving.value = false;
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .delete();

      myProducts.removeWhere((p) => p["id"] == productId);
      soldProducts.removeWhere((p) => p["id"] == productId);
    } catch (e) {}
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  Future<void> updateProduct({
    required String productId,
    required String newName,
    required String newPrice,
    required String newStatus,
    required String newdeskripsi,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection("products")
          .doc(productId);

      await docRef.update({
        "nama": newName,
        "harga": newPrice,
        "status": newStatus,
        "deskripsi": newdeskripsi,
      });

      final index = myProducts.indexWhere((p) => p["id"] == productId);
      final soldIndex = soldProducts.indexWhere((p) => p["id"] == productId);

      Map<String, dynamic> updated = {
        "id": productId,
        "name": newName,
        "price": newPrice,
        "status": newStatus,
        "deskripsi": newdeskripsi,
      };

      if (index != -1) {
        updated = {...myProducts[index], ...updated};
        myProducts[index] = updated;
      }

      if (soldIndex != -1) {
        updated = {...soldProducts[soldIndex], ...updated};
        soldProducts[soldIndex] = updated;
      }

      if (newStatus == "Terjual") {
        if (index != -1) {
          soldProducts.add(myProducts[index]);
          myProducts.removeAt(index);
        }
      } else {
        if (soldIndex != -1) {
          myProducts.add(soldProducts[soldIndex]);
          soldProducts.removeAt(soldIndex);
        }
      }
    } catch (e) {}
  }

  void logout() async {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah Anda yakin ingin keluar?',
      textCancel: 'Batal',
      textConfirm: 'Keluar',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await _statusService.setUserOffline();
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => const WelcomeView());
      },
    );
  }

  static String _formatTimestamp(dynamic ts) {
    try {
      if (ts == null) return "-";
      if (ts is String) {
        final dt = DateTime.parse(ts);
        return "${_monthName(dt.month)} ${dt.year}";
      }
      if (ts is Timestamp) {
        final dt = ts.toDate();
        return "${_monthName(dt.month)} ${dt.year}";
      }
      if (ts is DateTime) {
        return "${_monthName(ts.month)} ${ts.year}";
      }
    } catch (_) {}
    return "-";
  }

  static String _monthName(int m) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[(m - 1).clamp(0, 11)];
  }
}



