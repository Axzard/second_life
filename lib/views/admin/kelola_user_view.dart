import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/admin/kelola_user_viewmodel.dart';

class KelolaUserView extends StatelessWidget {
  const KelolaUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(KelolaUserViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text("Kelola User", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => vm.searchUser(val),
                  decoration: InputDecoration(
                    hintText: "Cari user...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => Row(
                  children: [
                    _buildFilterChip("Semua", vm.selectedFilter.value == "Semua", () => vm.selectFilter("Semua")),
                    const SizedBox(width: 8),
                    _buildFilterChip("Aktif", vm.selectedFilter.value == "Aktif", () => vm.selectFilter("Aktif")),
                    const SizedBox(width: 8),
                    _buildFilterChip("Banned", vm.selectedFilter.value == "Banned", () => vm.selectFilter("Banned")),
                  ],
                )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (vm.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vm.filteredUsers.isEmpty) {
                return const Center(child: Text("Tidak ada user"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vm.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = vm.filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF00775A),
                        child: Text(
                          user.namaLengkap.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "aktif",
                            child: const Text("Set Aktif"),
                            onTap: () => vm.ubahStatus(user.uid, "aktif"),
                          ),
                          PopupMenuItem(
                            value: "banned",
                            child: const Text("Ban User"),
                            onTap: () => vm.ubahStatus(user.uid, "banned"),
                          ),
                        ],
                      ),
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
        backgroundColor: selected ? const Color(0xFF00775A) : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
