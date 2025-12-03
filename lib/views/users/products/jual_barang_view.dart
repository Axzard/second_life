import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_life/viewmodels/users/products/jual_barang_viewmodel.dart';

class JualBarangView extends StatelessWidget {
  const JualBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(JualBarangViewModel());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Jual Barang",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => GestureDetector(
              onTap: vm.pickImages,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: vm.images.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload, size: 40, color: Color(0xFF00775A)),
                          SizedBox(height: 6),
                          Text(
                            "Upload",
                            style: TextStyle(
                              color: Color(0xFF00775A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: vm.images.map((img) {
                          final index = vm.images.indexOf(img);
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  img,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => vm.removeImage(index),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            )),
            Obx(() => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "${vm.images.length}/5 foto ditambahkan",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            )),
            const SizedBox(height: 20),
            Text("Nama Barang *", style: _labelStyle()),
            const SizedBox(height: 6),
            TextField(
              controller: vm.namaC,
              decoration: _inputDecoration("Contoh: Kamera DSLR Canon EOS 700D"),
            ),
            const SizedBox(height: 18),
            Text("Kategori *", style: _labelStyle()),
            const SizedBox(height: 6),
            Obx(() => vm.kategoriList.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text("Memuat kategori...", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : DropdownButtonFormField<String>(
                    value: vm.selectedKategori.value,
                    decoration: _dropdownDecoration(),
                    hint: const Text("Pilih kategori"),
                    items: vm.kategoriList
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: vm.setKategori,
                  )),
            const SizedBox(height: 18),
            Text("Kondisi Barang *", style: _labelStyle()),
            const SizedBox(height: 6),
            Obx(() => DropdownButtonFormField<String>(
              value: vm.selectedKondisi.value,
              hint: const Text("Pilih kondisi"),
              decoration: _dropdownDecoration(),
              items: vm.kondisiList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: vm.setKondisi,
            )),
            const SizedBox(height: 18),
            Text("Harga *", style: _labelStyle()),
            const SizedBox(height: 6),
            TextField(
              textInputAction: TextInputAction.next,
              controller: vm.hargaC,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Rp 0"),
            ),
            const SizedBox(height: 18),
            Text("Lokasi *", style: _labelStyle()),
            const SizedBox(height: 6),
            TextField(
              textInputAction: TextInputAction.next,
              controller: vm.lokasiC,
              decoration: _inputDecoration("Contoh: Jakarta Selatan")
                  .copyWith(prefixIcon: const Icon(Icons.location_on)),
            ),
            const SizedBox(height: 18),
            Text("Deskripsi *", style: _labelStyle()),
            const SizedBox(height: 6),
            TextField(
              controller: vm.deskripsiC,
              maxLines: 4,
              decoration: _inputDecoration(
                "Jelaskan detail kondisi barang, kelengkapan, alasan jual, dll.",
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Deskripsi yang lengkap akan menarik lebih banyak pembeli",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Batal", style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: vm.isLoading.value ? null : () => vm.postProduct(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00775A),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: vm.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Posting",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.black87,
    );
  }
}
