import 'package:get/get.dart';
import 'package:second_life/models/report/laporan_pengguna_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanPenggunaViewModel extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var laporanList = <LaporanModel>[].obs;
  var filteredList = <LaporanModel>[].obs;
  var isLoading = true.obs;
  var selectedFilter = "Semua".obs;

  @override
  void onInit() {
    super.onInit();
    loadLaporan();
  }

  Future<void> loadLaporan() async {
    isLoading.value = true;

    try {
      final snapshot = await _db
          .collection("laporan")
          .orderBy("timestamp", descending: true)
          .get();

      laporanList.value = snapshot.docs
          .map((doc) => LaporanModel.fromMap(doc.id, doc.data()))
          .toList();

      applyFilter();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error loading laporan: $e");
    }
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  void applyFilter() {
    if (selectedFilter.value == "Semua") {
      filteredList.value = laporanList;
    } else {
      filteredList.value = laporanList
          .where((lap) => lap.status.toLowerCase() == selectedFilter.value.toLowerCase())
          .toList();
    }
  }

  Future<void> updateStatus(String laporanId, String newStatus) async {
    try {
      await _db.collection("laporan").doc(laporanId).update({
        "status": newStatus,
      });

      await loadLaporan();

      Get.snackbar(
        "Success",
        "Status laporan berhasil diupdate",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengupdate status: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteLaporan(String laporanId) async {
    try {
      await _db.collection("laporan").doc(laporanId).delete();
      await loadLaporan();

      Get.snackbar(
        "Success",
        "Laporan berhasil dihapus",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus laporan: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

