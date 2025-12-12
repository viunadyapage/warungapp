import 'package:flutter/material.dart';
import '../../models/barang.dart';
import '../../services/barang_service.dart';
import '../../models/api_response.dart';
import 'barang_edit_screen.dart';

class BarangDetailScreen extends StatefulWidget {
  final Barang barang;
  const BarangDetailScreen({super.key, required this.barang});

  @override
  State<BarangDetailScreen> createState() => _BarangDetailScreenState();
}

class _BarangDetailScreenState extends State<BarangDetailScreen> {
  final Color primaryColor = const Color(0xFFaa3437);
  final Color appBarColor = const Color(0xFF95d1fc);
  final Color textColor = const Color(0xFF25231E);

  Barang? barang;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    barang = widget.barang;
  }

  // 🔥 fungsi refresh barang
  Future<void> _refreshData() async {
    setState(() => loading = true);

    ApiResponse res = await BarangService().getBarangById(barang!.id!);

    setState(() => loading = false);

    if (res.error == null) {
      setState(() {
        barang = res.data as Barang;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      appBar: AppBar(
        title: Text(barang?.namaBarang ?? "Detail Barang"),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshData, // 🔥 tidak keluar aplikasi lagi
          ),

          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BarangEditScreen(barang: barang!),
                ),
              );

              if (updated == true) {
                _refreshData();
              }
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detail("Nama", barang?.namaBarang),
                      _detail("Kode", barang?.kode),
                      _detail("Kategori", barang?.kategori),
                      _detail("Stok", barang?.stok.toString()),
                      _detail("Harga Beli", "Rp ${barang?.hargaBeli}"),
                      _detail("Harga Jual", "Rp ${barang?.hargaJual}"),

                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                          ),
                          onPressed: () async {
                            ApiResponse res =
                                await BarangService().deleteBarang(barang!.id!);

                            if (res.error == null) {
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Barang berhasil dihapus")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(res.error!)),
                              );
                            }
                          },
                          child: const Text(
                            "Hapus Barang",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _detail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        "$title: ${value ?? '-'}",
        style: TextStyle(fontSize: 17, color: textColor),
      ),
    );
  }
}
