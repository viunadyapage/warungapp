import 'package:flutter/material.dart';
import 'package:warungapp/screens/barang/barang_create_screen.dart';
import '../../services/barang_service.dart';
import '../../models/barang.dart';
import '../../models/api_response.dart';
import 'barang_detail_screen.dart';

class BarangListScreen extends StatefulWidget {
  const BarangListScreen({super.key});

  @override
  State<BarangListScreen> createState() => _BarangListScreenState();
}

class _BarangListScreenState extends State<BarangListScreen> {
  bool loading = true;
  List<Barang> barangList = [];

  final Color primaryColor = const Color(0xFFaa3437);  
  final Color appBarColor = const Color(0xFF95d1fc);  
  final Color textColor = const Color(0xFF25231E); 

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  void fetchBarang() async {
    ApiResponse response = await BarangService().getBarangList();

    if (response.error == null) {
      setState(() {
        barangList = response.data as List<Barang>;
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Daftar Barang", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() => loading = true);
              fetchBarang();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BarangCreateScreen()),
              ).then((value) {
                if (value == true) fetchBarang();
              });
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final barang = barangList[index];

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    title: Text(
                      barang.namaBarang ?? "-",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kode: ${barang.kode}"),
                        Text("Kategori: ${barang.kategori ?? '-'}"),
                        Text("Stok: ${barang.stok}"),
                        Text("Harga Jual: Rp ${barang.hargaJual}"),
                      ],
                    ),

                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 18, color: primaryColor),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarangDetailScreen(barang: barang),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
