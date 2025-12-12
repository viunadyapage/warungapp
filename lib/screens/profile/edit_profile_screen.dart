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
  final Color primaryColor = const Color(0xFFaa3437);   // background
  final Color appBarColor = const Color(0xFF95d1fc);    // top bar
  final Color textColor = const Color(0xFF25231E);

  User? user;
  bool loading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    ApiResponse res = await AuthService().getUser();

    if (res.error == null) {
      user = res.data as User;
      nameController.text = user!.name ?? "";
      emailController.text = user!.email ?? "";
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
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Edit Profil"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                _field("Nama", nameController),
                _field("Email", emailController),
                _field("Password Baru (opsional)", passController, isPassword: true),
                _field("Konfirmasi Password", confirmController, isPassword: true),

                const SizedBox(height: 20),

                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBarColor,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _saveProfile,
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
