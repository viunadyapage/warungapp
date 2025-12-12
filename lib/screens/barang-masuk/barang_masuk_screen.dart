import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/barang_service.dart';
import '../../services/barang_masuk_service.dart'; // <--- Tambahkan ini
import '../../services/supplier_service.dart';

class BarangMasukScreen extends StatefulWidget {
  const BarangMasukScreen({super.key});

  @override
  State<BarangMasukScreen> createState() => _BarangMasukScreenState();
}

class _BarangMasukScreenState extends State<BarangMasukScreen> {
  // --- Style Variables (Sesuai Tema Warung App) ---
  final Color primaryColor = const Color(0xFFaa3437); // Merah
  final Color appBarColor = const Color(0xFF95d1fc);  // Biru Muda
  final Color textColor = const Color(0xFF25231E);

  // --- State Variables ---
  bool _isLoading = false;      // Loading saat simpan data
  bool _isInitLoading = true;   // Loading awal saat ambil data dropdown
  
  List<dynamic> _supplierList = [];
  List<dynamic> _barangList = [];

  // --- Form Values ---
  int? _selectedSupplierId;
  int? _selectedBarangId;
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default tanggal hari ini
    _tanggalController.text = DateTime.now().toString().split(' ')[0];
    _fetchDropdownData();
  }

  // 1. Ambil Data Supplier & Barang untuk Dropdown
  void _fetchDropdownData() async {
    ApiResponse suppliersRes = await SupplierService().getSuppliers();
    // Perhatikan: Gunakan getBarangList() jika itu nama fungsi di service kamu
    ApiResponse barangRes = await BarangService().getBarangList(); 

    if (mounted) {
      setState(() {
        _isInitLoading = false;
        if (suppliersRes.error == null) {
          _supplierList = suppliersRes.data as List<dynamic>;
        }
        if (barangRes.error == null) {
          _barangList = barangRes.data as List<dynamic>;
        }
      });
    }
  }

  // 2. Logic Simpan Transaksi
  void _submit() async {
    if (_selectedSupplierId == null) {
      _showMsg("Pilih Supplier terlebih dahulu");
      return;
    }
    if (_selectedBarangId == null) {
      _showMsg("Pilih Barang terlebih dahulu");
      return;
    }
    if (_jumlahController.text.isEmpty) {
      _showMsg("Masukkan jumlah barang");
      return;
    }

    setState(() => _isLoading = true);

    ApiResponse res = await BarangMasukService().createBarangMasuk(
      supplierId: _selectedSupplierId!,
      barangId: _selectedBarangId!,
      jumlah: int.tryParse(_jumlahController.text) ?? 0,
      tanggal: _tanggalController.text,
    );

    setState(() => _isLoading = false);

    if (res.error == null) {
      if (mounted) {
        Navigator.pop(context, true); // Kembali & Refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stok berhasil ditambahkan!")),
        );
      }
    } else {
      _showMsg(res.error!);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Date Picker
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Input Pembelian", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isInitLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Dropdown Supplier ---
                      _label("Pilih Supplier"),
                      DropdownButtonFormField(
                        value: _selectedSupplierId,
                        items: _supplierList.map((item) {
                          String namaLabel = item['name'] ?? 
                                             item['nama_supplier'] ?? 
                                             item['nama'] ?? 
                                             "Supplier #${item['id']}";
                          return DropdownMenuItem(
                            value: int.parse(item['id'].toString()),
                            child: Text(namaLabel),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedSupplierId = val as int?),
                        decoration: _inputDecor("Cth: Toko Sembako Jaya"),
                      ),
                      const SizedBox(height: 16),

                      // --- Dropdown Barang ---
                      _label("Pilih Barang"),
                      DropdownButtonFormField(
                        value: _selectedBarangId,
                        items: _barangList.map((item) {
                          // item adalah object Barang, atau Map json.
                          // Sesuaikan akses datanya. Jika pakai Model Barang: item.namaBarang
                          // Jika Map: item['nama_barang']
                          // Kode di bawah asumsi 'item' adalah object Barang dari Model
                          return DropdownMenuItem(
                            value: item.id, 
                            child: Text("${item.kode} - ${item.namaBarang}"),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedBarangId = val as int?),
                        decoration: _inputDecor("Cari barang..."),
                      ),
                      const SizedBox(height: 16),

                      // --- Input Jumlah ---
                      _label("Jumlah Beli"),
                      TextField(
                        controller: _jumlahController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecor("0"),
                      ),
                      const SizedBox(height: 16),

                      // --- Input Tanggal ---
                      _label("Tanggal Transaksi"),
                      TextField(
                        controller: _tanggalController,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: _inputDecor("YYYY-MM-DD").copyWith(
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- Tombol Simpan ---
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appBarColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _submit,
                                child: const Text(
                                  "Simpan Transaksi",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  // Helper Widget untuk Label
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // Helper Decoration
  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}