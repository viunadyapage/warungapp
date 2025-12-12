import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/barang_masuk_service.dart';
import '../../services/barang_service.dart';
import '../../services/supplier_service.dart';
// import '../../models/barang.dart'; // Pastikan import model Barang jika ada

class BarangMasukScreen extends StatefulWidget {
  const BarangMasukScreen({super.key});

  @override
  State<BarangMasukScreen> createState() => _BarangMasukScreenState();
}

class _BarangMasukScreenState extends State<BarangMasukScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Warna Tema (Sesuai Screenshot Soft UI)
  final Color bgBlue = const Color(0xFFE3F2FD); 
  final Color bluePrimary = const Color(0xFF1976D2); 
  final Color inputGrey = const Color(0xFFF5F6FA); 

  bool _isLoading = false;      
  bool _isInitLoading = true;   
  
  List<dynamic> _supplierList = [];
  List<dynamic> _barangList = [];

  int? _selectedSupplierId;
  int? _selectedBarangId;
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tanggalController.text = DateTime.now().toString().substring(0, 10);
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    ApiResponse suppliersRes = await SupplierService().getSuppliers();
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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedSupplierId == null || _selectedBarangId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon pilih Supplier dan Barang")),
      );
      return;
    }

    setState(() => _isLoading = true);

    ApiResponse res = await BarangMasukService().createBarangMasuk(
      supplierId: _selectedSupplierId!,
      barangId: _selectedBarangId!,
      jumlah: int.parse(_jumlahController.text),
      tanggal: _tanggalController.text,
    );

    setState(() => _isLoading = false);

    if (res.error == null) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok berhasil ditambahkan!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  // Helper Style Input (Background Abu Soft, Tanpa Border)
  InputDecoration _softInputDecor(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54, size: 22),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none, // Hilangkan garis tepi
      ),
      filled: true,
      fillColor: inputGrey, // Warna 0xFFF5F6FA
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
        title: const Text("Input Stok Masuk", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: _isInitLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // ICON HEADER BULAT
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: Icon(Icons.input_rounded, size: 40, color: bluePrimary),
                  ),
                  
                  const SizedBox(height: 25),

                  // CARD FORM PUTIH
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
                          const Text("Informasi Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 20),

                          // --- DROPDOWN BARANG (SOLUSI ERROR 1: Pakai .id) ---
                          DropdownButtonFormField(
                            value: _selectedBarangId,
                            decoration: _softInputDecor("Pilih Barang", Icons.inventory_2_outlined),
                            isExpanded: true,
                            items: _barangList.map((item) {
                              // item adalah OBJECT (Barang), jadi pakai TITIK (.)
                              return DropdownMenuItem(
                                value: item.id as int, 
                                child: Text("${item.kode} - ${item.namaBarang}", overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedBarangId = val as int?),
                            validator: (val) => val == null ? "Pilih barang dulu" : null,
                          ),
                          const SizedBox(height: 15),

                          // --- DROPDOWN SUPPLIER (SOLUSI ERROR 2: Pakai ['id']) ---
                          DropdownButtonFormField(
                            value: _selectedSupplierId,
                            decoration: _softInputDecor("Pilih Supplier", Icons.local_shipping_outlined),
                            items: _supplierList.map((item) {
                              // Cek apakah item Map atau Object untuk keamanan
                              int id;
                              String nama;
                              
                              if (item is Map) {
                                id = int.parse(item['id'].toString());
                                nama = item['name'] ?? item['nama'] ?? item['nama_supplier'] ?? "Supplier";
                              } else {
                                // Jika ternyata Object
                                id = item.id;
                                nama = item.nama; 
                              }

                              return DropdownMenuItem(
                                value: id,
                                child: Text(nama),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedSupplierId = val as int?),
                            validator: (val) => val == null ? "Pilih supplier dulu" : null,
                          ),
                          const SizedBox(height: 15),

                          // --- INPUT JUMLAH ---
                          TextFormField(
                            controller: _jumlahController,
                            keyboardType: TextInputType.number,
                            decoration: _softInputDecor("Stok Masuk", Icons.add_box_rounded),
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
                                 initialDate: DateTime.now(),
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

                  // TOMBOL SIMPAN (BIRU BESAR)
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
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("Simpan Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}