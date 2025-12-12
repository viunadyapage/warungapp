import 'package:flutter/material.dart';
import '../barang/barang_list_screen.dart';
import '../profile/edit_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF95D1FC);
  static const Color accentBlue  = Color(0xFF608BAA);
  static const Color darkText    = Color(0xFF1F1D1A);

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
                  const SizedBox(height: 15),

                  // HEADER
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _glassBox(), // ⬅ softened
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "WarungKu App",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                            fontFamily: "CrimsonPro",
                          ),
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              color: accentBlue,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Menu Utama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: darkText.withOpacity(0.85),
                      fontFamily: "CrimsonPro",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // GRID MENU
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 22,
                      mainAxisSpacing: 22,
                      children: [
                        _menuButton(
                          label: "Barang Masuk",
                          icon: Icons.inventory_2_outlined,
                          onTap: () {},
                        ),
                        _menuButton(
                          label: "Barang Keluar",
                          icon: Icons.move_up_outlined,
                          onTap: () {},
                        ),
                        _menuButton(
                          label: "Lihat Barang",
                          icon: Icons.list_alt_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BarangListScreen()),
                            );
                          },
                        ),
                        _menuButton(
                          label: "Edit Profil",
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BUBBLE
  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.12), // ⬅ softened bubble glow
            blurRadius: 18,
            spreadRadius: 6,
          )
        ],
      ),
    );
  }

  // GLASSBOX FINAL (lebih lembut, tidak mencolok)
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

  // MENU CARD (shadow diperhalus)
  Widget _menuButton({
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
                    color: Colors.white.withOpacity(0.15), // ⬅ softened
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

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 52,
                    color: accentBlue,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    label,
                    style: TextStyle(
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
