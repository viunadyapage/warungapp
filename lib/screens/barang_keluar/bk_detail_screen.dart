import 'package:flutter/material.dart';
import '../../models/barang_keluar.dart';
import '../../services/barang_keluar_service.dart';
import '../../models/api_response.dart';
import 'bk_edit_screen.dart';

class BKDetailScreen extends StatefulWidget {
  final BarangKeluar bk;
  const BKDetailScreen({super.key, required this.bk});

  @override
  State<BKDetailScreen> createState() => _BKDetailScreenState();
}

class _BKDetailScreenState extends State<BKDetailScreen> {
  final Color blue = const Color(0xff95d1fc);
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color textColor = const Color(0xFF1A1B1E);
  final Color deleteBtn = const Color(0xFFD32F2F);

  late BarangKeluar bk;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    bk = widget.bk;
  }

  // ---------------- REFRESH API ----------------
  Future<void> _refreshData() async {
    setState(() => loading = true);
    ApiResponse res =
        await BarangKeluarService().getBarangKeluarById(bk.id!);
    setState(() => loading = false);

    if (res.error == null) {
      setState(() => bk = res.data as BarangKeluar);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.error!)));
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
          bk.namaBarang ?? "Detail Barang Keluar",
          style: const TextStyle(
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
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
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BKEditScreen(bk: bk),
                ),
              );

              if (changed == true) _refreshData();
            },
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: loading
          ? Center(child: CircularProgressIndicator(color: blue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _neumorphicCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER ICON
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: blue.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.move_up_rounded,
                                      size: 40, color: blue),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  bk.namaBarang ?? "-",
                                  style: TextStyle(
                                    fontFamily: "CrimsonPro",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  "Kode: ${bk.kodeBarang ?? '-'}",
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

                          _detailItem(Icons.numbers, "Jumlah",
                              "${bk.jumlah ?? 0}"),
                          _detailItem(Icons.info_outline, "Alasan",
                              bk.alasan ?? "-"),
                          _detailItem(Icons.date_range, "Tanggal",
                              bk.tanggal ?? "-"),
                          _detailItem(Icons.notes, "Keterangan",
                              bk.keterangan ?? "-"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---------------- DELETE BUTTON ----------------
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
                          ApiResponse res =
                              await BarangKeluarService().deleteBarangKeluar(bk.id!);

                          if (!mounted) return;

                          if (res.error == null) {
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Data barang keluar berhasil dihapus"),
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
                                "Hapus Data",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "CrimsonPro",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  // ---------------- WIDGETS ----------------

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

  Widget _detailItem(IconData icon, String label, String value) {
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
                value,
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
}
