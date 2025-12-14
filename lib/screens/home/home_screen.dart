import 'package:flutter/material.dart';
import '../barang/barang_list_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../barang-masuk/barang_masuk_list_screen.dart';
import '../barang_keluar/bk_list_screen.dart';
import '../auth/login_screen.dart';
import '../../services/auth_service.dart';
import '../../models/api_response.dart';

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
          // ================= BACKGROUND =================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF95D1FC),
                  Color(0xFFB7E3FF),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ================= BUBBLES =================
          Positioned(top: -30, right: -40, child: _bubble(140, 0.22)),
          Positioned(bottom: -40, left: -30, child: _bubble(180, 0.18)),

          // ================= CONTENT =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "WarungKu",
                        style: TextStyle(
                          fontFamily: "CrimsonPro",
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),

                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: _headerIconButton(
                          Icons.logout_rounded,
                          isLogout: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= MENU =================
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

  // ================= LOGOUT =================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              fontFamily: "CrimsonPro",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Yakin ingin keluar dari aplikasi?",
            style: TextStyle(fontFamily: "CrimsonPro"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);

                ApiResponse res = await AuthService().logout();

                if (!context.mounted) return;

                if (res.error == null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res.error!)),
                  );
                }
              },
              child: const Text(
                "Keluar",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= UI HELPERS =================

  Widget _menuCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: _glassBox(),
        child: Row(
          children: [
            Icon(icon, size: 32, color: accentBlue),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "CrimsonPro",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerIconButton(IconData icon, {bool isLogout = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isLogout
            ? Colors.red.withOpacity(0.12)
            : Colors.white.withOpacity(0.55),
        shape: BoxShape.circle,
        border: isLogout
            ? Border.all(color: Colors.red.withOpacity(0.3))
            : null,
      ),
      child: Icon(
        icon,
        color: isLogout ? Colors.red : accentBlue,
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
      ),
    );
  }

  BoxDecoration _glassBox() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.28),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(2, 4),
        )
      ],
    );
  }
}
