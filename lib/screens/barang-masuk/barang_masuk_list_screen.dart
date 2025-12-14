import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../models/barang_masuk.dart';
import '../../services/barang_masuk_service.dart';
import 'barang_masuk_screen.dart'; 
import 'barang_masuk_edit_screen.dart'; 
import 'barang_masuk_detail_screen.dart';

class BarangMasukListScreen extends StatefulWidget {
  const BarangMasukListScreen({super.key});

  @override
  State<BarangMasukListScreen> createState() => _BarangMasukListScreenState();
}

class _BarangMasukListScreenState extends State<BarangMasukListScreen> {
  // --- Warna Tema (Seragam dengan Create/Edit) ---
  final Color bgBlue = const Color(0xFFE3F2FD); 
  final Color bluePrimary = const Color(0xFF1976D2);
  final Color textDark = const Color(0xFF263238);

  List<BarangMasuk> _listData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // --- FUNGSI-FUNGSI LOGIKA (Tidak Berubah) ---
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

  void _deleteData(int id) async {
    ApiResponse res = await BarangMasukService().deleteBarangMasuk(id);
    if (res.error == null) {
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  // Navigasi ke Halaman Tambah
  void _navigateToAddScreen() {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarangMasukScreen()),
    ).then((val) {
      if (val == true) {
          setState(() => _loading = true);
          _fetchData();
      }
    });
  }

  // Menampilkan Opsi Edit/Hapus
  void _showOptions(BarangMasuk data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis kecil di atas modal
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded, color: Colors.blue),
                ),
                title: const Text("Edit Data", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Ubah jumlah atau tanggal transaksi"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarangMasukEditScreen(data: data)),
                  ).then((value) {
                    if (value == true) {
                        setState(() => _loading = true); 
                        _fetchData();
                    }
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
                title: const Text("Hapus Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: const Text("Data akan dihapus permanen"),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirm(data.id);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirm(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Transaksi?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Perhatian: Menghapus transaksi masuk akan otomatis mengurangi stok barang terkait."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
              _deleteData(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- BUILD UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue, // Latar belakang Biru Muda
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar Transparan
        elevation: 0,
        centerTitle: true,
        title: Text("Riwayat Stok Masuk", style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        leading: IconButton(
          // Tombol back jika halaman ini di-push, kalau halaman utama bisa diganti icon menu
          icon: Icon(Icons.arrow_back_ios_new, color: textDark),
          onPressed: () => Navigator.maybePop(context), 
        ),
        actions: [
          // Tombol Refresh di AppBar
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textDark),
            onPressed: () {
              setState(() => _loading = true);
              _fetchData();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      // Floating Action Button untuk Tambah Data
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddScreen,
        backgroundColor: bluePrimary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Input Stok", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchData(),
              child: _listData.isEmpty 
                ? Center(child: Text("Belum ada data transaksi masuk.", style: TextStyle(color: Colors.grey[600])))
                : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), // Padding bawah lebih besar agar tidak tertutup FAB
                  itemCount: _listData.length,
                  itemBuilder: (context, index) {
                    final item = _listData[index];
                    // Format tanggal
                    String tgl = item.tanggal.length >= 10 ? item.tanggal.substring(0, 10) : item.tanggal;
                    
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1), // Indikator Masuk (Hijau soft)
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.arrow_downward_rounded, color: Colors.green), 
                        ),
                        title: Text(
                          item.namaBarang ?? 'Tanpa Nama',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 5),
                                  Text(tgl, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.local_shipping_outlined, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 5),
                                  Expanded(child: Text("${item.namaSupplier ?? '-'}", style: TextStyle(fontSize: 13, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "+${item.jumlah}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                            ),
                            Text("Unit", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                        onTap: () async {
                          bool? refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarangMasukDetailScreen(data: item),
                            ),
                          );

                          if (refresh == true) {
                            setState(() => _loading = true);
                            _fetchData();
                          }
                        },
                        onLongPress: () => _showOptions(item),
                      ),
                    );
                  },
                ),
            ),
    );
  }
}