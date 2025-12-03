import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanModel {
  final String id;
  final String deskripsi;
  final String namaDilaporkan;
  final String jenisLaporan;
  final String namaPelapor;
  final String productName;
  final String status;
  final DateTime timestamp;


  // >>> FIELD GAMBAR / BUKTI LAPORAN
  final String bukti; // base64 atau url
  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  LaporanModel({
    required this.id,
    required this.deskripsi,
    required this.namaDilaporkan,
    required this.jenisLaporan,
    required this.namaPelapor,
    required this.productName,
    required this.status,
    required this.timestamp,

    required this.bukti,
  });

  factory LaporanModel.fromMap(String id, Map<String, dynamic> map) {
    return LaporanModel(
      id: id,
      deskripsi: map["deskripsi"] ?? "",
      namaDilaporkan: map["namaDilaporkan"] ?? "",
      jenisLaporan: map["jenisLaporan"] ?? "",
      namaPelapor: map["namaPelapor"] ?? "",
      productName: map["productName"] ?? "",
      status: map["status"] ?? "pending",
      timestamp: (map["timestamp"] as Timestamp).toDate(),
      // >>> FIELD GAMBAR
      bukti: map["bukti"] ?? "",
      // <<<<<<<<<<<<<<<<<<
    );
  }
}
