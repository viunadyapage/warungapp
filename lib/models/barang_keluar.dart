class BarangKeluar {
  int? id;
  int? barangId;
  int? jumlah;
  String? alasan;
  String? tanggal;
  String? keterangan;

  //relasi
  String? namaBarang;
  String? kodeBarang;

  BarangKeluar({
    this.id,
    this.barangId,
    this.jumlah,
    this.alasan,
    this.tanggal,
    this.keterangan,
    this.namaBarang,
    this.kodeBarang,
  });

  factory BarangKeluar.fromJson(Map<String, dynamic> json) {
    return BarangKeluar(
      id: json['id'],
      barangId: json['barang_id'],
      jumlah: json['jumlah'],
      alasan: json['alasan'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      namaBarang: json['barang']?['nama_barang'],
      kodeBarang: json['barang']?['kode'],
    );
  }
}
