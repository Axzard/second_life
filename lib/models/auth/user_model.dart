class UserModel {
  final String uid;
  final String namaLengkap;
  final String email;
  final String role;
  final String status;      
  final String bergabung;
  final String? profilePhoto;  // Base64 encoded photo
  final String? bio;           // User bio
  final String? noTelp;        // Phone number
  final String? alamat;        // Address

  UserModel({
    required this.uid,
    required this.namaLengkap,
    required this.email,
    required this.role,
    required this.status,
    required this.bergabung,
    this.profilePhoto,
    this.bio,
    this.noTelp,
    this.alamat,
  });

  // Compatibility getters for old code
  String get userId => uid;

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "namaLengkap": namaLengkap,
      "email": email,
      "role": role,
      "status": status,
      "bergabung": bergabung,
      "profilePhoto": profilePhoto,
      "bio": bio,
      "noTelp": noTelp,
      "alamat": alamat,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      namaLengkap: map["namaLengkap"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "user",
      status: map["status"] ?? "aktif",
      bergabung: map["bergabung"] ?? "",
      profilePhoto: map["profilePhoto"],
      bio: map["bio"],
      noTelp: map["noTelp"],
      alamat: map["alamat"],
    );
  }
}
