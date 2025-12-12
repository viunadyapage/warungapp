class Barang {
  int? id;
  String? kode;
  String? namaBarang;
  String? kategori;
  int? stok;
  double? hargaBeli;
  double? hargaJual;

  Barang({
    this.id,
    this.kode,
    this.namaBarang,
    this.kategori,
    this.stok,
    this.hargaBeli,
    this.hargaJual,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      kode: json['kode'],
      namaBarang: json['nama_barang'],
      kategori: json['kategori'],
      stok: json['stok'],
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0,
      hargaJual: double.tryParse(json['harga_jual'].toString()) ?? 0,
    );
  }
}