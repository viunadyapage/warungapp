import 'package:flutter/material.dart';
import '../barang/barang_list_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../barang-masuk/barang_masuk_list_screen.dart';
import '../barang_keluar/bk_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF95D1FC);
  static const Color accentBlue = Color(0xFF608BAA);
  static const Color darkText = Color(0xFF1F1D1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF95D1FC), // biru dominan
                  Color(0xFFB7E3FF), // biru soft transisi
                  Colors.white,      // fade ke putih
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // BUBBLES
          Positioned(top: -30, right: -40, child: _bubble(140, 0.22)),
          Positioned(bottom: -40, left: -30, child: _bubble(180, 0.18)),

          // CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Tambahan jarak agar tidak terlalu mepet atas
                  
                  // HEADER (Opsional: Jika ingin menampilkan tombol logout/profil di atas)
                  // Row(mainAxisAlignment: MainAxisAlignment.end, children: [_headerIconButton(Icons.logout, isLogout: true)]),
                  
                  const SizedBox(height: 20),

                  // MENU CARD 1: Barang Masuk
                  _menuCard(
                    context,
                    label: "Barang Masuk",
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BarangMasukListScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // MENU CARD 2: Barang Keluar
                  _menuCard(
                    context,
                    label: "Barang Keluar",
                    icon: Icons.logout_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BKListScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // MENU CARD 3: Lihat Barang
                  _menuCard(
                    context,
                    label: "Lihat Barang",
                    icon: Icons.list_alt_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BarangListScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // MENU CARD 4: Edit Profil
                  _menuCard(
                    context,
                    label: "Edit Profil",
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC LOGOUT ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi", style: TextStyle(fontFamily: "CrimsonPro", fontWeight: FontWeight.bold)),
          content: const Text("Yakin ingin keluar aplikasi?", style: TextStyle(fontFamily: "CrimsonPro")),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Colors.grey, fontFamily: "CrimsonPro")),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: "CrimsonPro")),
              onPressed: () async {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Logout (Simulasi)")));
              },
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET HELPER ---

  Widget _headerIconButton(IconData icon, {bool isLogout = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.55),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
        border: isLogout ? Border.all(color: Colors.red.withOpacity(0.2), width: 1) : null,
      ),
      child: Icon(
        icon,
        color: isLogout ? Colors.red : accentBlue,
        size: 26,
      ),
    );
  }

  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.12),
            blurRadius: 18,
            spreadRadius: 6,
          )
        ],
      ),
    );
  }

  BoxDecoration _glassBox() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.white.withOpacity(0.25),
      border: Border.all(
        color: Colors.white.withOpacity(0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(2, 4),
        )
      ],
    );
  }

  // PERBAIKAN: Nama diubah jadi _menuCard dan ditambahkan parameter context
  Widget _menuCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: 1),
      builder: (context, double value, child) {
        return GestureDetector(
          onTapDown: (_) => value = 0.94,
          onTapUp: (_) => value = 1,
          onTapCancel: () => value = 1,
          onTap: onTap,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: _glassBox().copyWith(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(-2, -2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row( // Saya ganti Column jadi Row biar lebih rapi ke samping (opsional)
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 32, // Ukuran icon saya sesuaikan sedikit
                    color: accentBlue,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontFamily: "CrimsonPro",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}