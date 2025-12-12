class BarangMasuk {
  final int id;
  final int barangId;
  final int supplierId;
  final int jumlah;
  final String tanggal;
  final String? namaBarang;   // Tambahan field
  final String? namaSupplier; // Tambahan field

  BarangMasuk({
    required this.id,
    required this.barangId,
    required this.supplierId,
    required this.jumlah,
    required this.tanggal,
    this.namaBarang,
    this.namaSupplier,
  });

  factory BarangMasuk.fromJson(Map<String, dynamic> json) {
    return BarangMasuk(
      id: int.parse(json['id'].toString()),
      barangId: int.parse(json['barang_id'].toString()),
      supplierId: int.parse(json['supplier_id'].toString()),
      
      // PERBAIKAN DISINI: Gunakan 'jumlah' (sesuai Laravel kamu)
      jumlah: int.parse(json['jumlah'].toString()), 
      
      tanggal: json['tanggal_masuk'] ?? '',
      
      // Handle null safety untuk relasi
      namaBarang: json['barang'] != null ? json['barang']['nama_barang'] : 'Unknown',
      namaSupplier: json['supplier'] != null ? json['supplier']['name'] : 'Unknown', // Cek controller, relasinya 'supplier' -> 'name' atau 'nama_supplier'? Di search query kamu pakai 'name'.
    );
  }
}