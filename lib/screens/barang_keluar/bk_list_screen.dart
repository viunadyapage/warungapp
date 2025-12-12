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

  final Color blueMain = const Color(0xFF95D1FC);
  final Color blueDark = const Color(0xFF608BAA);
  final Color textDark = const Color(0xFF1F1D1A);

  @override
  void initState() {
    super.initState();
    fetchBK();
  }

  void fetchBK() async {
    ApiResponse res = await BarangKeluarService().getBarangKeluarList();

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
    return Scaffold(
      body: Stack(
        children: [
          // --------------------- BACKGROUND ----------------------
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF95D1FC),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned(top: -40, right: -20, child: _bubble(150, 0.22)),
          Positioned(bottom: -50, left: -10, child: _bubble(180, 0.18)),
          Positioned(top: 200, left: -20, child: _bubble(80, 0.16)),

          // --------------------- MAIN CONTENT ----------------------
          SafeArea(
            child: Column(
              children: [
                _header(),

                Expanded(
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: listBK.length,
                          itemBuilder: (context, i) {
                            final bk = listBK[i];
                            return _bkCard(bk);
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

  // ------------------ HEADER GLASS STYLE -------------------
  Widget _header() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: _glass().copyWith(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Barang Keluar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: "Crimson Pro",
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
                  MaterialPageRoute(builder: (_) => const BKCreateScreen()),
                ).then((value) {
                  if (value == true) fetchBK();
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  // ------------------ BK CARD ----------------------
  Widget _bkCard(BarangKeluar bk) {
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
        decoration: _glass().copyWith(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              blurRadius: 18,
              offset: const Offset(-4, -4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bk.namaBarang ?? "-",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
                fontFamily: "Crimson Pro",
              ),
            ),
            const SizedBox(height: 10),
            Text("Jumlah: ${bk.jumlah}", style: const TextStyle(fontFamily: "Crimson Pro")),
            Text("Alasan: ${bk.alasan}", style: const TextStyle(fontFamily: "Crimson Pro")),
            Text("Tanggal: ${bk.tanggal}", style: const TextStyle(fontFamily: "Crimson Pro")),
          ],
        ),
      ),
    );
  }

  // ----------------- GLASS DECORATION -----------------
  BoxDecoration _glass() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.35),
      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(3, 6),
        ),
      ],
    );
  }

  // ----------------- BUBBLE -----------------
  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  // ----------------- CIRCLE BUTTON -----------------
  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }
}
