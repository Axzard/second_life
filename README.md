# Second Life - Flutter Mobile Application

> Aplikasi marketplace untuk jual-beli barang bekas dengan fitur chat real-time

## 📱 Tentang Aplikasi

Second Life adalah aplikasi mobile marketplace yang memungkinkan pengguna untuk menjual dan membeli barang bekas dengan mudah. Aplikasi ini dilengkapi dengan sistem autentikasi, manajemen produk, favorit, dan chat real-time.

## ✨ Fitur Utama

### 👤 User Features
- **Autentikasi**: Login, Register, Forgot Password, Google Sign-In
- **Home Page**: Tampilan produk dengan filter kategori dan sorting
- **Product Details**: Detail produk lengkap dengan gambar slider
- **Chat**: Real-time messaging dengan penjual
- **Favorites**: Simpan produk favorit
- **Sell Products**: Jual barang bekas dengan upload foto
- **Profile**: Manajemen profil pengguna

### 👨‍💼 Admin Features
- **Dashboard**: Statistik dan overview sistem
- **Kelola User**: Manajemen pengguna
- **Kelola Product**: Manajemen produk
- **Kelola Category**: Manajemen kategori
- **Laporan**: Sistem pelaporan pengguna

## 🏗️ Arsitektur

**Pattern**: MVVM (Model-View-ViewModel)
**State Management**: GetX
**Backend**: Firebase (Auth, Firestore)

`
lib/
├── models/          # Data models
├── services/        # Business logic & API calls
├── viewmodels/      # State management (GetX Controllers)
├── views/           # UI Screens
├── widgets/         # Reusable components
└── utils/           # Helper functions
`

## 🎨 Responsive Design

✅ **Fully Responsive** - Aplikasi telah dioptimasi untuk berbagai ukuran layar:

- **Mobile** (< 600px): 2 kolom grid
- **Tablet** (600-900px): 3 kolom grid
- **Desktop** (> 900px): 4 kolom grid

### Fitur Responsive:
- Dynamic grid layout
- Scalable fonts dan icons
- Adaptive padding dan spacing
- Text overflow protection
- No bottom overflow issues

Lihat dokumentasi lengkap di: [RESPONSIVE_FIXES.md](RESPONSIVE_FIXES.md)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK
- Android Studio / VS Code
- Firebase Account

### Installation

1. Clone repository
`ash
git clone <repository-url>
cd Project-Second-Life-main
`

2. Install dependencies
`ash
flutter pub get
`

3. Setup Firebase
   - Buat project di Firebase Console
   - Download google-services.json untuk Android
   - Download GoogleService-Info.plist untuk iOS
   - Letakkan di folder yang sesuai

4. Run aplikasi
`ash
flutter run
`

## 📦 Dependencies

`yaml
dependencies:
  flutter: sdk: flutter
  get: ^4.7.3                    # State management
  firebase_core: ^4.2.1          # Firebase core
  firebase_auth: ^6.1.2          # Authentication
  cloud_firestore: ^6.1.0        # Database
  google_sign_in: ^7.2.0         # Google auth
  carousel_slider: ^5.1.1        # Image slider
  image_picker: ^1.2.1           # Pick images
  google_maps_flutter: ^2.13.1   # Maps integration
  shared_preferences: ^2.5.3     # Local storage
  skeletonizer: ^2.1.1          # Loading skeleton
  # ... dan lainnya
`

## 🛠️ Development

### Struktur File Penting

`
lib/
├── main.dart                           # Entry point
├── views/
│   ├── auth/                          # Authentication screens
│   ├── admin/                         # Admin screens
│   └── users/                         # User screens
│       ├── home_user_view.dart       # Home page (RESPONSIVE ✅)
│       ├── favorite_view.dart        # Favorites (RESPONSIVE ✅)
│       └── products/
│           └── product_detail_view.dart  # Detail (RESPONSIVE ✅)
├── widgets/
│   └── users/
│       ├── products/
│       │   └── product_card.dart     # Product card (RESPONSIVE ✅)
│       └── product_details/          # Detail widgets (RESPONSIVE ✅)
└── utils/
    └── responsive_helper.dart        # Responsive utility (NEW ✨)
`

### Responsive Helper Usage

`dart
import 'package:second_life/utils/responsive_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);
    
    return Container(
      padding: r.allPadding,
      child: Text(
        'Hello',
        style: TextStyle(
          fontSize: r.fontSize(mobile: 14, tablet: 16, desktop: 18),
        ),
      ),
    );
  }
}
`

Lihat guide lengkap: [RESPONSIVE_HELPER_GUIDE.md](RESPONSIVE_HELPER_GUIDE.md)

## 🐛 Bug Fixes & Improvements

### Latest Update (December 2025)
✅ Fixed bottom overflow issues on product pages
✅ Made all widgets responsive across devices
✅ Improved layout hierarchy
✅ Added responsive helper utility
✅ Better text overflow handling
✅ Optimized for mobile, tablet, and desktop

Lihat changelog: [RESPONSIVE_FIXES.md](RESPONSIVE_FIXES.md)

## 📄 Documentation

- [RESPONSIVE_FIXES.md](RESPONSIVE_FIXES.md) - Detail perbaikan responsive
- [RESPONSIVE_HELPER_GUIDE.md](RESPONSIVE_HELPER_GUIDE.md) - Guide penggunaan helper
- [BEFORE_AFTER_COMPARISON.txt](BEFORE_AFTER_COMPARISON.txt) - Perbandingan sebelum/sesudah
- [IMPLEMENTATION_COMPLETE.txt](IMPLEMENTATION_COMPLETE.txt) - Summary implementasi
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Migration guide
- [GETX_CONVERSION_REPORT.md](GETX_CONVERSION_REPORT.md) - GetX conversion report

## 🧪 Testing

### Run Analysis
`ash
flutter analyze
`

### Run Tests
`ash
flutter test
`

### Run on Device
`ash
flutter run
`

## 📱 Screenshots

> TODO: Tambahkan screenshots aplikasi

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

Developed by: [Your Name]
Semester: 7 - Mobile Lanjutan

## 📞 Support

Untuk pertanyaan atau bantuan, silakan hubungi:
- Email: [your-email@example.com]
- GitHub Issues: [repository-url/issues]

---

**Last Updated**: December 2025
**Status**: ✅ Production Ready (Responsive Design Implemented)
