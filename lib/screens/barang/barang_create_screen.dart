import 'package:flutter/material.dart';
import '../../services/barang_service.dart';
import '../../models/api_response.dart';

class BarangCreateScreen extends StatefulWidget {
  const BarangCreateScreen({super.key});

  @override
  State<BarangCreateScreen> createState() => _BarangCreateScreenState();
}

class _BarangCreateScreenState extends State<BarangCreateScreen> {
  final Color primaryColor = const Color(0xFFaa3437);   // background merah
  final Color appBarColor = const Color(0xFF95d1fc);    // biru muda
  final Color textColor = const Color(0xFF25231E);

  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaBeliController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();

  bool loading = false;

  void _createBarang() async {
    setState(() => loading = true);

    ApiResponse res = await BarangService().createBarang(
      kode: kodeController.text.trim(),
      nama: namaController.text.trim(),
      kategori: kategoriController.text.trim(),
      stok: int.tryParse(stokController.text) ?? 0,
      hargaBeli: double.tryParse(hargaBeliController.text) ?? 0,
      hargaJual: double.tryParse(hargaJualController.text) ?? 0,
    );

    setState(() => loading = false);

    if (res.error == null) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang berhasil ditambahkan")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Tambah Barang", style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                _field("Kode Barang", kodeController),
                _field("Nama Barang", namaController),
                _field("Kategori", kategoriController),
                _field("Stok", stokController, number: true),
                _field("Harga Beli", hargaBeliController, number: true),
                _field("Harga Jual", hargaJualController, number: true),

                const SizedBox(height: 20),

                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBarColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _createBarang,
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
