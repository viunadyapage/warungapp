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
  final Color primaryColor = const Color(0xFFaa3437);
  final Color appBarColor = const Color(0xFF95d1fc);
  final Color textColor = const Color(0xFF25231E);

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

    if (res.error == null) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang berhasil diupdate")),
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
      resizeToAvoidBottomInset: true, // <-- FIX overflow
      appBar: AppBar(
        title: const Text("Edit Barang"),
        backgroundColor: appBarColor,
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
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: _saveChanges,
                    child: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(color: Colors.white),
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
