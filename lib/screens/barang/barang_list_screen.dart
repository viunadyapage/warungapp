import 'package:flutter/material.dart';
import 'package:warungapp/screens/barang/barang_create_screen.dart';
import '../../services/barang_service.dart';
import '../../models/barang.dart';
import '../../models/api_response.dart';
import 'barang_detail_screen.dart';

class BarangListScreen extends StatefulWidget {
  const BarangListScreen({super.key});

  @override
  State<BarangListScreen> createState() => _BarangListScreenState();
}

class _BarangListScreenState extends State<BarangListScreen> {
  bool loading = true;
  List<Barang> barangList = [];

  final Color blueMain = const Color(0xFF95D1FC);
  final Color blueDark = const Color(0xFF608BAA);
  final Color textDark = const Color(0xFF1F1D1A);

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  void fetchBarang() async {
    ApiResponse response = await BarangService().getBarangList();

    if (response.error == null) {
      setState(() {
        barangList = response.data as List<Barang>;
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ----------------------------------------------------------
          // Background gradient + bubbles
          // ----------------------------------------------------------
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

          // ----------------------------------------------------------
          // Main content
          // ----------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                _header(),

                Expanded(
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: barangList.length,
                          itemBuilder: (context, index) {
                            final barang = barangList[index];
                            return _barangCard(barang);
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

  // ------------------------------------------------------------------
  // Header AppBar Style Glassmorphism
  // ------------------------------------------------------------------
  Widget _header() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: _glass().copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Daftar Barang",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          Row(
            children: [
              _circleButton(Icons.refresh, () {
                setState(() => loading = true);
                fetchBarang();
              }),

              const SizedBox(width: 10),

              _circleButton(Icons.add, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BarangCreateScreen(),
                  ),
                ).then((value) {
                  if (value == true) fetchBarang();
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // Bubble illustration
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // Glass effect shared style
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // Single barang card (glassmorphism + soft shadow)
  // ------------------------------------------------------------------
  Widget _barangCard(Barang barang) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BarangDetailScreen(barang: barang),
          ),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
              barang.namaBarang ?? "-",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),

            const SizedBox(height: 10),

            Text("Kode: ${barang.kode}"),
            Text("Kategori: ${barang.kategori ?? '-'}"),
            Text("Stok: ${barang.stok}"),
            Text("Harga Jual: Rp ${barang.hargaJual}"),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Small rounded action button
  // ------------------------------------------------------------------
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
