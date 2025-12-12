import 'package:flutter/material.dart';
import '../../models/barang_keluar.dart';
import '../../services/barang_keluar_service.dart';
import '../../models/api_response.dart';

class BKEditScreen extends StatefulWidget {
  final BarangKeluar bk;
  const BKEditScreen({super.key, required this.bk});

  @override
  State<BKEditScreen> createState() => _BKEditScreenState();
}

class _BKEditScreenState extends State<BKEditScreen> {
  final Color blue = const Color(0xff95d1fc);
  final Color softBackground = const Color(0xFFEFF3FF);
  final Color primaryDark = const Color(0xFF1565C0);
  final Color textDark = const Color(0xFF1A1B1E);

  late TextEditingController jumlahC;
  late TextEditingController tanggalC;
  late TextEditingController ketC;

  String? alasanSelected;

  final List<String> alasanList = [
    "rusak",
    "hilang",
    "kadaluwarsa",
    "internal",
    "lainnya",
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    jumlahC = TextEditingController(text: widget.bk.jumlah?.toString() ?? "0");
    tanggalC = TextEditingController(text: widget.bk.tanggal ?? "");
    ketC = TextEditingController(text: widget.bk.keterangan ?? "");
    alasanSelected = widget.bk.alasan ?? alasanList.first;
  }

  // ---------------- DATE PICKER ----------------
  Future<void> pickDate() async {
    DateTime initialDate = DateTime.tryParse(widget.bk.tanggal ?? "") ?? DateTime.now();

    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
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

  // ---------------- UPDATE API ----------------
  Future<void> updateBK() async {
    setState(() => loading = true);

    ApiResponse res = await BarangKeluarService().updateBarangKeluar(
      id: widget.bk.id!,
      barangId: widget.bk.barangId!,
      jumlah: int.tryParse(jumlahC.text) ?? widget.bk.jumlah ?? 0,
      alasan: alasanSelected ?? alasanList.first,
      tanggal: tanggalC.text,
      keterangan: ketC.text,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (res.error == null) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.error!)));
    }
  }

  @override
  void dispose() {
    jumlahC.dispose();
    tanggalC.dispose();
    ketC.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Barang Keluar",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "CrimsonPro",
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ICON HEADER
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
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Icon(Icons.move_up_rounded, size: 40, color: blue),
              ),
            ),

            // CARD EDIT FORM
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA6B4C8).withOpacity(0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Jumlah"),
                  const SizedBox(height: 6),
                  _inputText(jumlahC, icon: Icons.onetwothree, isNumber: true),

                  const SizedBox(height: 20),

                  _label("Alasan Pengeluaran"),
                  const SizedBox(height: 6),
                  _dropdownAlasan(),

                  const SizedBox(height: 20),

                  _label("Tanggal"),
                  const SizedBox(height: 6),
                  _dateField(),

                  const SizedBox(height: 20),

                  _label("Keterangan (Opsional)"),
                  const SizedBox(height: 6),
                  _inputText(ketC, maxLines: 3),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // BUTTON SAVE
            loading
                ? CircularProgressIndicator(color: blue)
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: primaryDark.withOpacity(0.4),
                      ),
                      onPressed: updateBK,
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "CrimsonPro",
                          fontSize: 18,
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

  // ---------------- WIDGET HELPERS ----------------

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontFamily: "CrimsonPro",
          fontSize: 14,
          color: textDark,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _inputText(
    TextEditingController c, {
    IconData? icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
          fontFamily: "CrimsonPro",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.black45) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _dropdownAlasan() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: alasanSelected,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(
          fontFamily: "CrimsonPro",
          fontSize: 16,
          color: Colors.black,
        ),
        items: alasanList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toUpperCase()),
                ))
            .toList(),
        onChanged: (v) => setState(() => alasanSelected = v),
      ),
    );
  }

  Widget _dateField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: tanggalC,
        readOnly: true,
        onTap: pickDate,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.calendar_month, color: Colors.black54),
        ),
      ),
    );
  }
}
