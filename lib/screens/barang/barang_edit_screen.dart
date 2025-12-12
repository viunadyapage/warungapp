import 'package:flutter/material.dart';
import '../../models/barang.dart';
import '../../services/barang_service.dart';
import '../../models/api_response.dart';

class BarangEditScreen extends StatefulWidget {
  final Barang barang;
  const BarangEditScreen({super.key, required this.barang});

  @override
  State<BarangEditScreen> createState() => _BarangEditScreenState();
}

class _BarangEditScreenState extends State<BarangEditScreen> {
  // Palet Warna (Konsisten dengan Detail Screen)
  final Color blue = const Color(0xff95d1fc); 
  final Color primaryDark = const Color(0xFF1565C0); // Warna biru tua untuk teks/tombol
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color textDark = const Color(0xFF1A1B1E);

  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController stokController;
  late TextEditingController hargaBeliController;
  late TextEditingController hargaJualController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.barang.namaBarang);
    kategoriController = TextEditingController(text: widget.barang.kategori);
    stokController = TextEditingController(text: widget.barang.stok.toString());
    hargaBeliController = TextEditingController(text: widget.barang.hargaBeli.toString());
    hargaJualController = TextEditingController(text: widget.barang.hargaJual.toString());
  }

  // --------------------------------
  // 🔵 LOGIC: SAVE CHANGES
  // --------------------------------
  void _saveChanges() async {
    setState(() => loading = true);

    ApiResponse res = await BarangService().updateBarang(
      id: widget.barang.id!,
      nama: namaController.text,
      kategori: kategoriController.text,
      stok: int.tryParse(stokController.text) ?? 0,
      hargaBeli: double.tryParse(hargaBeliController.text) ?? 0,
      hargaJual: double.tryParse(hargaJualController.text) ?? 0,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (res.error == null) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error!)),
      );
    }
  }

  // --------------------------------
  // 🔵 UI BUILD
  // --------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Data Barang",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Icon
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                     BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                  ]
                ),
                child: Icon(Icons.edit_note_rounded, size: 40, color: blue),
              ),
            ),

            // Form Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA6B4C8).withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputLabel("Informasi Dasar"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: namaController,
                    hint: "Nama Barang",
                    icon: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: kategoriController,
                    hint: "Kategori",
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: stokController,
                    hint: "Stok",
                    icon: Icons.onetwothree_outlined,
                    isNumber: true,
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  _inputLabel("Harga"),
                  const SizedBox(height: 12),
                  
                  // Row untuk Harga agar sejajar
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: hargaBeliController,
                          hint: "Beli",
                          icon: Icons.arrow_downward_rounded,
                          isNumber: true,
                          prefixText: "Rp ",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: hargaJualController,
                          hint: "Jual",
                          icon: Icons.arrow_upward_rounded,
                          isNumber: true,
                          prefixText: "Rp ",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Simpan
            loading
                ? Center(child: CircularProgressIndicator(color: blue))
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: primaryDark.withOpacity(0.4),
                      ),
                      onPressed: _saveChanges,
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "CrimsonPro",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // --------------------------------
  // 🔵 WIDGET HELPER
  // --------------------------------
  
  Widget _inputLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "CrimsonPro",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 0, 0, 0),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Background abu-abu sangat muda
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          fontFamily: "CrimsonPro",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0), size: 22),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(14),
             borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}