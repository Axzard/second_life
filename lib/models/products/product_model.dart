
class ProductModel {
  final String id;
  final String userId;
  final String nama;       
  final String kategori;
  final String kondisi;    
  final String harga;      
  final String lokasi;     
  final String deskripsi;
  final List<String> images; 
  final String createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.nama,
    required this.kategori,
    required this.kondisi,
    required this.harga,
    required this.lokasi,
    required this.deskripsi,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "nama": nama,
      "kategori": kategori,
      "kondisi": kondisi,
      "harga": harga,
      "lokasi": lokasi,
      "deskripsi": deskripsi,
      "images": images,
      "createdAt": createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"] ?? "",
      userId: map["userId"] ?? "",
      nama: map["nama"] ?? "",
      kategori: map["kategori"] ?? "",
      kondisi: map["kondisi"] ?? "",
      harga: map["harga"] ?? "",
      lokasi: map["lokasi"] ?? "",
      deskripsi: map["deskripsi"] ?? "",
      images: map["images"] != null ? List<String>.from(map["images"]) : [],
      createdAt: map["createdAt"] ?? "",
    );
  }
}
