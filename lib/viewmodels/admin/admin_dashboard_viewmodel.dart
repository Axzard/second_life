import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboardViewModel extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var totalUser = 0.obs;
  var userAktif = 0.obs;
  var productTotal = 0.obs;
  var produkAktif = 0.obs;
  var totalChat = 0.obs;
  var chatActive = 0.obs;
  var totalLaporan = 0.obs;
  var laporanSelesai = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  String percentString(int part, int total) {
    if (total == 0) return "0%";
    double p = (part / total) * 100;
    return "${p.toStringAsFixed(1)}%";
  }

  String get persenUserAktif => percentString(userAktif.value, totalUser.value);
  String get persenProdukAktif => percentString(produkAktif.value, productTotal.value);
  String get persenChatAktif => percentString(chatActive.value, totalChat.value);
  String get persenLaporanSelesai => percentString(laporanSelesai.value, totalLaporan.value);

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      final userSnap = await _db.collection("users").get();
      totalUser.value = userSnap.docs.length;
      userAktif.value = userSnap.docs
          .where((d) => d.data()["status"] == "aktif")
          .length;

      final productSnap = await _db.collection("products").get();
      productTotal.value = productSnap.docs.length;
      produkAktif.value = productTotal.value;

      final chatSnap = await _db.collection("chats").get();
      totalChat.value = chatSnap.docs.length;
      chatActive.value = chatSnap.docs
          .where((d) =>
              (d.data()["lastMessage"] ?? "").toString().isNotEmpty)
          .length;

      final laporanSnap = await _db.collection("laporan").get();
      totalLaporan.value = laporanSnap.docs.length;
      laporanSelesai.value = laporanSnap.docs
          .where((d) => d.data()["status"] == "selesai")
          .length;

    } catch (e) {
      print("Error: $e");
    }

    isLoading.value = false;
  }
}
