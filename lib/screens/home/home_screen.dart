import 'package:flutter/material.dart';
import '../barang/barang_list_screen.dart';
import '../profile/edit_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryColor = const Color(0xFFaa3437);   // background merah
  final Color appBarColor = const Color(0xFF95d1fc);    // biru muda
  final Color iconColor = const Color(0xFF608baa);      // biru gelap aksen
  final Color textColor = const Color(0xFF25231E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          "Warung App",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 2,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,

                children: [
                  _menuCard(
                    context,
                    label: "Barang Masuk",
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      // TODO: Barang masuk screen
                    },
                  ),

                  _menuCard(
                    context,
                    label: "Barang Keluar",
                    icon: Icons.logout_outlined,
                    onTap: () {
                      // TODO: Barang keluar screen
                    },
                  ),

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
          ],
        ),
      ),
    );
  }

  // ==============================================================
  //  CARD BUILDER
  // ==============================================================
  Widget _menuCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,                          // card putih
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            const SizedBox(height: 10),

            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
                fontFamily: "CrimsonPro",   // Font baru
              ),
            ),
          ],
        ),
      ),
    );
  }
}
