import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../models/barang_masuk.dart';
import '../../services/barang_masuk_service.dart';
import '../../services/barang_service.dart';
import '../../services/supplier_service.dart';

class BarangMasukEditScreen extends StatefulWidget {
  final BarangMasuk data; // Data yang mau diedit
  const BarangMasukEditScreen({super.key, required this.data});

  @override
  State<BarangMasukEditScreen> createState() => _BarangMasukEditScreenState();
}

class _BarangMasukEditScreenState extends State<BarangMasukEditScreen> {
  final Color primaryColor = const Color(0xFFaa3437);
  final Color appBarColor = const Color(0xFF95d1fc);

  bool _isLoading = false;
  List<dynamic> _supplierList = [];
  List<dynamic> _barangList = [];

  late int? _selectedSupplierId;
  late int? _selectedBarangId;
  late TextEditingController _jumlahController;
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data form
    _selectedSupplierId = widget.data.supplierId;
    _selectedBarangId = widget.data.barangId;
    _jumlahController = TextEditingController(text: widget.data.jumlah.toString());
   String tglBersih = widget.data.tanggal;
    if (tglBersih.length >= 10) {
      tglBersih = tglBersih.substring(0, 10);
    }
    _tanggalController = TextEditingController(text: tglBersih);
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    // Panggil SupplierService dan BarangService (Bukan BarangMasukService)
    var sRes = await SupplierService().getSuppliers();
    var bRes = await BarangService().getBarangList(); // <--- Ini butuh BarangService
    
    if (mounted) {
      setState(() {
        if (sRes.error == null) _supplierList = sRes.data as List<dynamic>;
        if (bRes.error == null) _barangList = bRes.data as List<dynamic>;
      });
    }
  }

  void _update() async {
    setState(() => _isLoading = true);

    // Panggil BarangMasukService untuk Update
    ApiResponse res = await BarangMasukService().updateBarangMasuk(
      id: widget.data.id, // Pastikan id di model bukan null
      supplierId: _selectedSupplierId!,
      barangId: _selectedBarangId!,
      jumlah: int.parse(_jumlahController.text),
      tanggal: _tanggalController.text,
    );

    setState(() => _isLoading = false);

    if (res.error == null) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil diupdate")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  // Gunakan DatePicker yg sama seperti di create screen
  // ... (copy fungsi _selectDate dari create screen) ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Edit Transaksi", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Dropdown Supplier
                DropdownButtonFormField(
                  value: _selectedSupplierId,
                  decoration: const InputDecoration(
                    labelText: "Pilih Supplier", 
                    border: OutlineInputBorder()
                  ),
                  items: _supplierList.map((item) {
                    // LOGIC PERBAIKAN:
                    // Coba ambil 'name', kalau kosong ambil 'nama_supplier', 
                    // kalau kosong ambil 'nama', kalau masih kosong tampilkan ID.
                    String namaLabel = item['name'] ?? 
                                       item['nama_supplier'] ?? 
                                       item['nama'] ?? 
                                       "Supplier #${item['id']}";

                    return DropdownMenuItem(
                      value: int.parse(item['id'].toString()), // Pastikan ID jadi int
                      child: Text(namaLabel), 
                    );
                  }).toList(),
                  onChanged: (val) {
                     setState(() => _selectedSupplierId = val as int?);
                  },
                ),

                // Dropdown Barang
                DropdownButtonFormField(
                  value: _selectedBarangId,
                  items: _barangList.map((item) => DropdownMenuItem(
                    value: item.id, child: Text("${item.kode} - ${item.namaBarang}"),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedBarangId = val as int?),
                  decoration: const InputDecoration(labelText: "Barang", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),

                // Jumlah
                TextField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Jumlah", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),

                // Tanggal (Bisa pake DatePicker atau manual dulu)
                TextField(
                  controller: _tanggalController,
                  decoration: const InputDecoration(labelText: "Tanggal (YYYY-MM-DD)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appBarColor, padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: _isLoading ? null : _update,
                    child: _isLoading ? const CircularProgressIndicator() : const Text("Update", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}