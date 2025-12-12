import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../models/barang_masuk.dart';
import '../../services/barang_masuk_service.dart';
import '../../services/barang_service.dart';
import '../../services/supplier_service.dart';

class BarangMasukEditScreen extends StatefulWidget {
  final BarangMasuk data;
  const BarangMasukEditScreen({super.key, required this.data});

  @override
  State<BarangMasukEditScreen> createState() => _BarangMasukEditScreenState();
}

class _BarangMasukEditScreenState extends State<BarangMasukEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final Color bgBlue = const Color(0xFFE3F2FD);
  final Color bluePrimary = const Color(0xFF1976D2);
  final Color inputGrey = const Color(0xFFF5F6FA);

  bool _isLoading = false;
  List<dynamic> _supplierList = [];
  List<dynamic> _barangList = [];

  int? _selectedSupplierId;
  int? _selectedBarangId;
  late TextEditingController _jumlahController;
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    _selectedSupplierId = widget.data.supplierId;
    _selectedBarangId = widget.data.barangId;
    _jumlahController = TextEditingController(text: widget.data.jumlah.toString());
    
    String tgl = widget.data.tanggal;
    if (tgl.length >= 10) tgl = tgl.substring(0, 10);
    _tanggalController = TextEditingController(text: tgl);

    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    var sRes = await SupplierService().getSuppliers();
    var bRes = await BarangService().getBarangList();
    if (mounted) {
      setState(() {
        if (sRes.error == null) _supplierList = sRes.data as List<dynamic>;
        if (bRes.error == null) _barangList = bRes.data as List<dynamic>;
      });
    }
  }

  void _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    ApiResponse res = await BarangMasukService().updateBarangMasuk(
      id: widget.data.id,
      supplierId: _selectedSupplierId!,
      barangId: _selectedBarangId!,
      jumlah: int.parse(_jumlahController.text),
      tanggal: _tanggalController.text,
    );

    setState(() => _isLoading = false);

    if (res.error == null) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil diperbarui!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  InputDecoration _softInputDecor(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54, size: 22),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: inputGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Stok Masuk", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // ICON HEADER (EDIT)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Icon(Icons.edit_note_rounded, size: 40, color: bluePrimary),
            ),
            
            const SizedBox(height: 25),

            // CARD FORM
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Edit Informasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 20),

                    // --- DROPDOWN BARANG (SOLUSI ERROR 1: Pakai .id) ---
                    DropdownButtonFormField(
                      value: _selectedBarangId,
                      decoration: _softInputDecor("Barang", Icons.inventory_2_outlined),
                      isExpanded: true,
                      items: _barangList.map((item) {
                        return DropdownMenuItem(
                          value: item.id as int,
                          child: Text("${item.kode} - ${item.namaBarang}", overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedBarangId = val as int?),
                    ),
                    const SizedBox(height: 15),

                    // --- DROPDOWN SUPPLIER (SOLUSI ERROR 2: Cek Tipe Data) ---
                    DropdownButtonFormField(
                      value: _selectedSupplierId,
                      decoration: _softInputDecor("Supplier", Icons.local_shipping_outlined),
                      items: _supplierList.map((item) {
                        int id;
                        String nama;
                        // Handling Aman: Cek apakah item itu Map atau Object
                        if (item is Map) {
                          id = int.parse(item['id'].toString());
                          nama = item['name'] ?? item['nama'] ?? item['nama_supplier'] ?? "Supplier";
                        } else {
                          id = item.id;
                          nama = item.nama;
                        }
                        return DropdownMenuItem(
                          value: id,
                          child: Text(nama),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSupplierId = val as int?),
                    ),
                    const SizedBox(height: 15),

                    // --- INPUT JUMLAH ---
                    TextFormField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: _softInputDecor("Jumlah", Icons.add_box_rounded),
                      validator: (val) => val!.isEmpty ? "Isi jumlah" : null,
                    ),
                    const SizedBox(height: 15),

                    // --- INPUT TANGGAL ---
                    TextFormField(
                      controller: _tanggalController,
                      readOnly: true,
                      decoration: _softInputDecor("Tanggal", Icons.calendar_today_rounded),
                      onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.tryParse(_tanggalController.text) ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _tanggalController.text = picked.toString().substring(0, 10));
                          }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL UPDATE
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bluePrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                onPressed: _isLoading ? null : _update,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}