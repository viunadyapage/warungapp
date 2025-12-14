import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../models/barang_masuk.dart';
import '../../services/barang_masuk_service.dart';
import 'barang_masuk_edit_screen.dart'; // <--- JANGAN LUPA IMPORT INI

class BarangMasukDetailScreen extends StatefulWidget {
  final BarangMasuk data;
  const BarangMasukDetailScreen({super.key, required this.data});

  @override
  State<BarangMasukDetailScreen> createState() => _BarangMasukDetailScreenState();
}

class _BarangMasukDetailScreenState extends State<BarangMasukDetailScreen> {
  // --- Warna Konsisten ---
  final Color blue = const Color(0xff95d1fc);
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color textColor = const Color(0xFF1A1B1E);
  final Color deleteBtn = const Color(0xFFD32F2F);
  final Color greenAccent = const Color(0xFF2E7D32);

  late BarangMasuk transaction;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    transaction = widget.data;
  }

  // Fungsi Refresh (Opsional)
  Future<void> _refreshData() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 500)); 
    setState(() => loading = false);
  }

  // --- NAVIGASI KE EDIT ---
  void _navigateToEdit() async {
    bool? updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarangMasukEditScreen(data: transaction),
      ),
    );

    // Jika data berhasil diupdate di halaman edit
    if (updated == true && mounted) {
      // Kita kembali ke halaman List agar list-nya refresh otomatis
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil diperbarui")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format Tanggal
    String displayDate = transaction.tanggal.length >= 10 
        ? transaction.tanggal.substring(0, 10) 
        : transaction.tanggal;

    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // TOMBOL EDIT (BARU)
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit Data',
            onPressed: _navigateToEdit,
          ),
          // TOMBOL REFRESH
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: blue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // --- KARTU INFORMASI (NEUMORPHIC) ---
                  _neumorphicCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Header (Icon & Nama Barang)
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: greenAccent.withOpacity(0.1), 
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.arrow_downward_rounded,
                                      size: 40, color: greenAccent),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  transaction.namaBarang ?? "Tanpa Nama",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  "ID Transaksi: ${transaction.id}",
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 40, thickness: 1),

                          // 2. Detail Grid
                          _detailItem(Icons.calendar_today_rounded, "Tanggal Masuk", displayDate),
                          _detailItem(Icons.local_shipping_outlined, "Supplier", transaction.namaSupplier),
                          
                          const SizedBox(height: 10),

                          // 3. Highlight Jumlah
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: greenAccent.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: greenAccent.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Jumlah Ditambahkan",
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "+ ${transaction.jumlah}",
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: greenAccent,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Unit / Pcs",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- TOMBOL HAPUS ---
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
                        onTap: _showDeleteConfirmDialog,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.delete_forever_rounded, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "Hapus Transaksi",
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

  // --- LOGIC HAPUS ---
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Konfirmasi Hapus", style: TextStyle(fontFamily: "CrimsonPro", fontWeight: FontWeight.bold)),
        content: const Text(
          "Apakah Anda yakin? Stok barang akan otomatis berkurang kembali.",
          style: TextStyle(fontFamily: "CrimsonPro"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: deleteBtn),
            onPressed: () async {
              Navigator.pop(context); 
              setState(() => loading = true);

              ApiResponse res = await BarangMasukService().deleteBarangMasuk(transaction.id);

              if (!mounted) return;
              setState(() => loading = false);

              if (res.error == null) {
                Navigator.pop(context, true); // Kembali ke list & refresh
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Transaksi dihapus, stok dikembalikan.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(res.error!)),
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
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
          const BoxShadow(
            color: Colors.white,
            blurRadius: 20,
            offset: Offset(-8, -8),
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
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}