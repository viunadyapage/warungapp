import 'package:flutter/material.dart';
import '../../services/barang_keluar_service.dart';
import '../../models/barang_keluar.dart';
import '../../models/api_response.dart';
import 'bk_detail_screen.dart';
import 'bk_create_screen.dart';

class BKListScreen extends StatefulWidget {
  const BKListScreen({super.key});

  @override
  State<BKListScreen> createState() => _BKListScreenState();
}

class _BKListScreenState extends State<BKListScreen> {
  bool loading = true;
  List<BarangKeluar> listBK = [];

  final Color textDark = const Color(0xFF1F1D1A);

  @override
  void initState() {
    super.initState();
    fetchBK();
  }

  void fetchBK() async {
    ApiResponse res = await BarangKeluarService().getBarangKeluarList();

    if (!mounted) return;

    if (res.error == null) {
      setState(() {
        listBK = res.data as List<BarangKeluar>;
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF95D1FC), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: _glass(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Barang Keluar",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          _circleButton(Icons.refresh, () {
                            setState(() => loading = true);
                            fetchBK();
                          }),
                          const SizedBox(width: 10),
                          _circleButton(Icons.add, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BKCreateScreen()),
                            ).then((value) {
                              if (value == true) fetchBK();
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                // LIST
                Expanded(
                  child: loading
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: listBK.length,
                          itemBuilder: (context, i) {
                            final bk = listBK[i];
                            return _bkCard(context, bk);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bkCard(BuildContext context, BarangKeluar bk) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BKDetailScreen(bk: bk)),
        ).then((value) {
          if (value == true) fetchBK();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: _glass(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bk.namaBarang ?? "-",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text("Jumlah: ${bk.jumlah}"),
            Text("Alasan: ${bk.alasan}"),
            Text("Tanggal: ${bk.tanggal}"),
          ],
        ),
      ),
    );
  }

  BoxDecoration _glass() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.35),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(3, 6),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}
