class BarangMasuk {
  int? id;
  int? barangId;
  int? jumlah;
  double? harga;
  String? tanggalMasuk;

  BarangMasuk({
    this.id,
    this.barangId,
    this.jumlah,
    this.harga,
    this.tanggalMasuk,
  });

  factory BarangMasuk.fromJson(Map<String, dynamic> json) {
    return BarangMasuk(
      id: json['id'],
      barangId: json['barang_id'],
      jumlah: json['jumlah'],
      harga: double.tryParse(json['harga'].toString()) ?? 0,
      tanggalMasuk: json['tanggal_masuk'],
    );
  }
}
