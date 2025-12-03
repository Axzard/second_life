import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> report({
    required String jenisLaporan,
    required String namaPelapor,
    required String namaDilaporkan,
    required String productName,
    required String deskripsi,
    required String buktiBase64,
  }) async {
    await _db.collection("laporan").add({
      "jenisLaporan": jenisLaporan,
      "namaPelapor": namaPelapor,
      "namaDilaporkan": namaDilaporkan,
      "productName": productName,
      "deskripsi": deskripsi,
      "bukti": buktiBase64,
      "timestamp": FieldValue.serverTimestamp(),
      "status": "pending",
    });
  }
}
