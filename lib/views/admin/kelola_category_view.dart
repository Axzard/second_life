import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/admin/kelola_category_viewmodel.dart';

class KelolaKategoriView extends StatelessWidget {
  const KelolaKategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(KelolaKategoriViewModel());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text("Kelola Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (vm.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(vm),
              icon: const Icon(Icons.add),
              label: const Text("Tambah Kategori"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00775A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            ...vm.category.map((cat) {
              final totalProduct = vm.totalProducts[cat.id] ?? 0;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("$totalProduct produk"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => vm.confirmEdit(cat.id, cat.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => vm.confirmDelete(cat.id, cat.name),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      }),
    );
  }

  void _showAddDialog(KelolaKategoriViewModel vm) {
    final TextEditingController nameC = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Tambah Kategori"),
        content: TextField(
          controller: nameC,
          decoration: const InputDecoration(
            labelText: "Nama Kategori",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          Obx(() => ElevatedButton(
            onPressed: vm.actionLoading.value
                ? null
                : () async {
                    final name = nameC.text.trim();
                    if (name.isEmpty) return;
                    await vm.addCategory(name);
                    Get.back();
                  },
            child: vm.actionLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Simpan"),
          )),
        ],
      ),
    );
  }
}
