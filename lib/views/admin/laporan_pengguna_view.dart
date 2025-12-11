import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/admin/laporan_pengguna_viewmodel.dart';

class LaporanPenggunaView extends StatelessWidget {
  const LaporanPenggunaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(LaporanPenggunaViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text(
          "Kelola Laporan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => Row(
                children: [
                  _buildFilterChip(
                    "Semua",
                    vm.selectedFilter.value == "Semua",
                    () => vm.selectFilter("Semua"),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    "Pending",
                    vm.selectedFilter.value == "pending",
                    () => vm.selectFilter("pending"),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    "Selesai",
                    vm.selectedFilter.value == "selesai",
                    () => vm.selectFilter("selesai"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (vm.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vm.filteredList.isEmpty) {
                return const Center(child: Text("Tidak ada laporan"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vm.filteredList.length,
                itemBuilder: (context, index) {
                  final laporan = vm.filteredList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(
                        laporan.jenisLaporan,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Dilaporkan: ${laporan.namaDilaporkan}"),
                      trailing: Chip(
                        label: Text(laporan.status),
                        backgroundColor: laporan.status == "pending"
                            ? Colors.orange
                            : Colors.green,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pelapor: ${laporan.namaPelapor}"),
                              const SizedBox(height: 8),
                              Text("Produk: ${laporan.productName}"),
                              const SizedBox(height: 8),
                              Text("Deskripsi: ${laporan.deskripsi}"),
                              const SizedBox(height: 16),
                              laporan.bukti.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Bukti:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // TAMPILKAN GAMBAR DARI BASE64
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.memory(
                                            base64Decode(laporan.bukti),
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text("Bukti: Tidak ada bukti"),

                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => vm.updateStatus(
                                        laporan.id,
                                        "selesai",
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text(
                                        "Tandai Selesai",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          vm.deleteLaporan(laporan.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected
            ? const Color(0xFF00775A)
            : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
