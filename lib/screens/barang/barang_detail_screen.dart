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
  // Warna
  final Color blue = const Color(0xff95d1fc);
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color textColor = const Color(0xFF1A1B1E);
  final Color deleteBtn = const Color(0xFFD32F2F);

  Barang? barang;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    barang = widget.barang;
  }

  Future<void> _refreshData() async {
    setState(() => loading = true);
    ApiResponse res = await BarangService().getBarangById(barang!.id!);
    setState(() => loading = false);

    if (res.error == null) {
      setState(() {
        barang = res.data as Barang;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          barang?.namaBarang ?? "Detail Barang",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BarangEditScreen(barang: barang!),
                ),
              );
              if (updated == true) _refreshData();
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: blue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // --- KARTU INFORMASI BARANG (NEUMORPHIC) ---
                  _neumorphicCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Header (Icon & Nama)
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: blue.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.inventory_2_outlined,
                                      size: 40, color: blue),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  barang?.namaBarang ?? "-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  "Kode: ${barang?.kode ?? "-"}",
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 40, thickness: 1),

                          // 2. Grid Detail (Kategori & Stok)
                          _detailItem(Icons.category_outlined, "Kategori",
                              barang?.kategori),
                          _detailItem(Icons.storage_rounded, "Stok Tersedia",
                              "${barang?.stok ?? 0}"),

                          const SizedBox(height: 10),

                          // 3. Kotak Harga
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: Column(
                              children: [
                                _priceRow("Harga Beli", barang?.hargaBeli),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                      // FIXED: Menghapus borderStyle dashed yang eror
                                      color: Colors.grey[400],
                                      thickness: 0.5),
                                ),
                                _priceRow("Harga Jual", barang?.hargaJual,
                                    isBold: true),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- TOMBOL HAPUS (DESAIN BARU) ---
                  Container(
                    decoration: BoxDecoration(
                      color: deleteBtn,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: deleteBtn.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          // Logika Hapus
                          ApiResponse res =
                              await BarangService().deleteBarang(barang!.id!);

                          if (!mounted) return;

                          if (res.error == null) {
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Barang berhasil dihapus"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(res.error!)),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.delete_outline_rounded,
                                  color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "Hapus Barang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "CrimsonPro",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _neumorphicCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: softBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 20,
            offset: const Offset(-8, -8),
          ),
          BoxShadow(
            color: const Color(0xFFA6B4C8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _detailItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: "CrimsonPro",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? "-",
                style: const TextStyle(
                  fontFamily: "CrimsonPro",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1B1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FIXED: Mengubah tipe parameter price dari int? menjadi num?
  // Agar bisa menerima double maupun int.
  Widget _priceRow(String label, num? price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "CrimsonPro",
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Text(
          "Rp ${price ?? 0}",
          style: TextStyle(
            fontFamily: "CrimsonPro",
            fontSize: isBold ? 20 : 18,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF2E7D32) : const Color(0xFF1A1B1E),
          ),
        ),
      ],
    );
  }
}