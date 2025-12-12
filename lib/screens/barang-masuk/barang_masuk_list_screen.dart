import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../models/barang_masuk.dart';
import '../../services/barang_service.dart';
import '../../services/barang_masuk_service.dart'; // Pastikan ini ada
import 'barang_masuk_screen.dart'; // File Create yang kamu buat sebelumnya
import 'barang_masuk_edit_screen.dart'; // File Edit (ada di bawah)

class BarangMasukListScreen extends StatefulWidget {
  const BarangMasukListScreen({super.key});

  @override
  State<BarangMasukListScreen> createState() => _BarangMasukListScreenState();
}

class _BarangMasukListScreenState extends State<BarangMasukListScreen> {
  // --- Style Variables ---
  final Color primaryColor = const Color(0xFFaa3437);
  final Color appBarColor = const Color(0xFF95d1fc);
  final Color textColor = const Color(0xFF25231E);

  List<BarangMasuk> _listData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Ambil data dari API
  void _fetchData() async {
    ApiResponse res = await BarangMasukService().getBarangMasukList();
    if (mounted) {
      setState(() {
        _loading = false;
        if (res.error == null) {
          _listData = res.data as List<BarangMasuk>;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
        }
      });
    }
  }

  // Fungsi Hapus Data
  void _deleteData(int id) async {
    ApiResponse res = await BarangMasukService().deleteBarangMasuk(id);
    if (res.error == null) {
      _fetchData(); // Refresh list setelah hapus
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  // Tampilkan Modal Opsi (Edit / Delete)
  void _showOptions(BarangMasuk data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Data"),
                onTap: () {
                  Navigator.pop(context); // Tutup modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarangMasukEditScreen(data: data),
                    ),
                  ).then((value) {
                    if (value == true) _fetchData(); // Refresh jika ada perubahan
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Hapus Data"),
                onTap: () {
                  Navigator.pop(context); // Tutup modal
                  _showDeleteConfirm(data.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus
  void _showDeleteConfirm(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus data ini? Stok barang mungkin akan berkurang."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteData(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Riwayat Barang Masuk", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          // --- TOMBOL REFRESH (BARU) ---
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Refresh Data',
            onPressed: () {
              // Set loading true agar loading spinner muncul
              setState(() => _loading = true);
              // Panggil ulang data dari API
              _fetchData();
            },
          ),
          
          // --- TOMBOL TAMBAH (YANG LAMA) ---
          IconButton(
            icon: const Icon(Icons.add_box_rounded, size: 30, color: Colors.black),
            tooltip: 'Tambah Transaksi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BarangMasukScreen()),
              ).then((val) {
                if (val == true) _fetchData();
              });
            },
          )
        ],
      ),
      
      // ... bagian body tetap sama ...
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _listData.length,
              itemBuilder: (context, index) {
                final item = _listData[index];
                return Card(
                  // ... kode tampilan card tetap sama ...
                  child: ListTile(
                    // ... kode list tile tetap sama ...
                    title: Text(item.namaBarang ?? '-'),
                    subtitle: Text("Jml: ${item.jumlah} | Tgl: ${item.tanggal.length >= 10 ? item.tanggal.substring(0, 10) : item.tanggal}"),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () => _showOptions(item),
                  ),
                );
              },
            ),
    );
  }
}