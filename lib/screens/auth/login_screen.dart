import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../models/api_response.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color primaryColor = const Color(0xFFaa3437);   // background merah
  final Color appBarColor = const Color(0xFF95d1fc);    // top bar biru muda
  final Color textColor = const Color(0xFF25231E);      // warna teks gelap
  final Color buttonColor = const Color(0xFF608baa);    // biru aksen

  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void _loginUser() async {
    setState(() => loading = true);

    ApiResponse res = await AuthService().login(
      emailController.text.trim(),
      passController.text.trim(),
    );

    setState(() => loading = false);

    if (res.error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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

      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Masuk", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 2,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ================== IKON APLIKASI ==================
              Image.asset(
                "assets/icons/transicon.png",
                width: 130,
                height: 130,
              ),

              const SizedBox(height: 25),

              // ================== CARD FORM LOGIN ==================
              Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 25),

                      loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 30,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _loginUser,
                              child: const Text(
                                "Masuk",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "CrimsonPro",
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
