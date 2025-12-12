import 'package:flutter/material.dart';
import '../../services/barang_keluar_service.dart';
import '../../services/barang_service.dart';
import '../../models/api_response.dart';
import '../../models/barang.dart';

class BKCreateScreen extends StatefulWidget {
  const BKCreateScreen({super.key});

  @override
  State<BKCreateScreen> createState() => _BKCreateScreenState();
}

class _BKCreateScreenState extends State<BKCreateScreen> {
  // PALET WARNA PREMIUM
  final Color blue = const Color(0xff95d1fc);
  final Color primaryDark = const Color(0xFF1565C0);
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color textDark = const Color(0xFF1A1B1E);

  // DATA DROPDOWN
  List<Barang> barangList = [];
  Barang? selectedBarang;

  final List<String> alasanList = [
    "rusak",
    "hilang",
    "kadaluwarsa",
    "internal",
    "lainnya",
  ];
  String? selectedAlasan;

  // CONTROLLER
  final TextEditingController jumlahC = TextEditingController();
  final TextEditingController tanggalC = TextEditingController();
  final TextEditingController ketC = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    tanggalC.text = DateTime.now().toIso8601String().split("T")[0];
    loadBarang();
  }

  // ---------------- LOAD BARANG DROPDOWN ----------------
  Future<void> loadBarang() async {
    ApiResponse res = await BarangService().getBarangList();
    if (res.error == null) {
      setState(() {
        barangList = res.data as List<Barang>;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res.error!)));
      }
    }
  }

  // ---------------- DATE PICKER ----------------
  Future<void> pickDate() async {
    DateTime initialDate = DateTime.tryParse(tanggalC.text) ?? DateTime.now();

    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff95d1fc)),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        tanggalC.text = selected.toIso8601String().split("T")[0];
      });
    }
  }

  // ---------------- SAVE DATA ----------------
  Future<void> saveBK() async {
    if (selectedBarang == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih barang terlebih dahulu")));
      return;
    }
    if (selectedAlasan == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih alasan terlebih dahulu")));
      return;
    }

    setState(() => loading = true);

    ApiResponse res = await BarangKeluarService().createBarangKeluar(
      barangId: selectedBarang!.id!,
      jumlah: int.tryParse(jumlahC.text) ?? 0,
      alasan: selectedAlasan!,
      tanggal: tanggalC.text,
      keterangan: ketC.text,
    );

    setState(() => loading = false);

    if (res.error == null) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang keluar berhasil ditambahkan")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error!)),
      );
    }
  }

  // ========================== UI ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tambah Barang Keluar",
          style: TextStyle(
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            // HEADER ICON
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: blue.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10)),
                  ],
                ),
                child: Icon(Icons.move_up_rounded, size: 40, color: blue),
              ),
            ),

            // CARD FORM
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
                  _label("Pilih Barang"),
                  const SizedBox(height: 6),
                  _dropdownBarang(),

                  const SizedBox(height: 20),

                  _label("Jumlah Barang"),
                  const SizedBox(height: 6),
                  _inputField(jumlahC, icon: Icons.onetwothree, isNumber: true),

                  const SizedBox(height: 20),

                  _label("Alasan Pengeluaran"),
                  const SizedBox(height: 6),
                  _dropdownAlasan(),

                  const SizedBox(height: 20),

                  _label("Tanggal Pengeluaran"),
                  const SizedBox(height: 6),
                  _dateField(),

                  const SizedBox(height: 20),

                  _label("Keterangan (Opsional)"),
                  const SizedBox(height: 6),
                  _inputField(ketC, maxLines: 3),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BUTTON SIMPAN
            loading
                ? CircularProgressIndicator(color: blue)
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: primaryDark.withOpacity(0.4),
                      ),
                      onPressed: saveBK,
                      child: const Text(
                        "Simpan",
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

  // -------------------- WIDGET HELPERS --------------------

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "CrimsonPro",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
    );
  }

  Widget _dropdownBarang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _decor(),
      child: DropdownButtonFormField<Barang>(
        value: selectedBarang,
        decoration: const InputDecoration(border: InputBorder.none),
        items: barangList
            .map((b) => DropdownMenuItem(
                  value: b,
                  child: Text("${b.kode} - ${b.namaBarang}",
                      style: const TextStyle(fontFamily: "CrimsonPro")),
                ))
            .toList(),
        onChanged: (v) => setState(() => selectedBarang = v),
      ),
    );
  }

  Widget _dropdownAlasan() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _decor(),
      child: DropdownButtonFormField<String>(
        value: selectedAlasan,
        decoration: const InputDecoration(border: InputBorder.none),
        items: alasanList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toUpperCase(),
                      style: const TextStyle(fontFamily: "CrimsonPro")),
                ))
            .toList(),
        onChanged: (v) => setState(() => selectedAlasan = v),
      ),
    );
  }

  Widget _dateField() {
    return Container(
      decoration: _decor(),
      child: TextField(
        controller: tanggalC,
        readOnly: true,
        onTap: pickDate,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.calendar_month, color: Colors.black54),
        ),
        style: const TextStyle(fontFamily: "CrimsonPro"),
      ),
    );
  }

  Widget _inputField(
    TextEditingController c, {
    IconData? icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: _decor(),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontFamily: "CrimsonPro"),
      ),
    );
  }

  BoxDecoration _decor() {
    return BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(14),
    );
  }
}
