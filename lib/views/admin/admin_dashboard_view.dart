import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/admin/admin_dashboard_viewmodel.dart';
import 'package:second_life/views/admin/kelola_user_view.dart';
import 'package:second_life/views/admin/kelola_product_view.dart';
import 'package:second_life/views/admin/kelola_category_view.dart';
import 'package:second_life/views/admin/laporan_pengguna_view.dart';
import 'package:second_life/widgets/admin/summary_card.dart';
import 'package:second_life/widgets/admin/menu_item_card.dart';

class HomeAdminView extends StatelessWidget {
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(AdminDashboardViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        elevation: 0,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => vm.loadDashboardData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Apakah Anda yakin ingin keluar?",
                textCancel: "Batal",
                textConfirm: "Logout",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  Get.offAllNamed('/welcome');
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ringkasan Statistik",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: "Total User",
                      count: vm.totalUser.value.toString(),
                      percent: vm.persenUserAktif,
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: "Total Produk",
                      count: vm.productTotal.value.toString(),
                      percent: vm.persenProdukAktif,
                      icon: Icons.shopping_bag,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: "Total Chat",
                      count: vm.totalChat.value.toString(),
                      percent: vm.persenChatAktif,
                      icon: Icons.chat,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: "Total Laporan",
                      count: vm.totalLaporan.value.toString(),
                      percent: vm.persenLaporanSelesai,
                      icon: Icons.report,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Menu Kelola",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              MenuItemCard(
                title: "Kelola User",
                icon: Icons.people,
                onTap: () => Get.to(() => const KelolaUserView()),
              ),
              const SizedBox(height: 12),
              MenuItemCard(
                title: "Kelola Produk",
                icon: Icons.shopping_bag,
                onTap: () => Get.to(() => const KelolaProductView()),
              ),
              const SizedBox(height: 12),
              MenuItemCard(
                title: "Kelola Kategori",
                icon: Icons.category,
                onTap: () => Get.to(() => const KelolaKategoriView()),
              ),
              const SizedBox(height: 12),
              MenuItemCard(
                title: "Kelola Laporan",
                icon: Icons.report,
                onTap: () => Get.to(() => const LaporanPenggunaView()),
              ),
            ],
          ),
        );
      }),
    );
  }
}
