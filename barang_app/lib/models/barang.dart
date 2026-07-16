class Barang {
  final int? id;
  final String kodeBarang;
  final String namaBarang;
  final String satuan;
  final int harga;
  final String keterangan;

  Barang({
    this.id,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.harga,
    required this.keterangan,
  });

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'],
      kodeBarang: map['kode_barang'],
      namaBarang: map['nama_barang'],
      satuan: map['satuan'],
      harga: map['harga'],
      keterangan: map['keterangan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode_barang': kodeBarang,
      'nama_barang': namaBarang,
      'satuan': satuan,
      'harga': harga,
      'keterangan': keterangan,
    };
  }
}
