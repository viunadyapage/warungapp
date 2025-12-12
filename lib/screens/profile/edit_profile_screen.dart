import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/api_response.dart';
import '../../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color blueMain = const Color(0xFF95D1FC);   // Biru utama
  final Color blueAccent = const Color(0xFF6BB8F5); // Biru lebih kuat

  User? user;
  bool loading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    ApiResponse res = await AuthService().getUser();

    if (res.error == null) {
      user = res.data as User;
      nameController.text = user?.name ?? "";
      emailController.text = user?.email ?? "";
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  void _saveProfile() async {
    setState(() => loading = true);

    ApiResponse res = await AuthService().updateProfile(
      nameController.text.trim(),
      emailController.text.trim(),
      passController.text.trim(),
      confirmController.text.trim(),
    );

    setState(() => loading = false);

    if (res.error == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------------------------------
      // APPBAR
      // -------------------------------
      appBar: AppBar(
        backgroundColor: blueMain,
        elevation: 0,
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // -------------------------------
      // BACKGROUND GRADIENT
      // -------------------------------
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF95D1FC), // biru dominan
              Color(0xFFB7E3FF), // biru lebih soft
              Colors.white,      // putih (paling bawah)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.55, 1.0], // biru dominan 55%
          ),
        ),

        // -------------------------------
        // FORM CARD
        // -------------------------------
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 7,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  _inputField(
                    label: "Nama",
                    controller: nameController,
                    icon: Icons.person,
                  ),

                  _inputField(
                    label: "Email",
                    controller: emailController,
                    icon: Icons.email,
                  ),

                  _inputField(
                    label: "Password Baru (opsional)",
                    controller: passController,
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  _inputField(
                    label: "Konfirmasi Password",
                    controller: confirmController,
                    icon: Icons.lock_reset,
                    isPassword: true,
                  ),

                  const SizedBox(height: 22),

                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueMain,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Simpan Perubahan",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // INPUT FIELD COMPONENT
  // -------------------------------
  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87),

          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),

          filled: true,
          fillColor: const Color(0xFFF8F8F8),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: blueAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
