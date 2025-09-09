class Alumni {
  final int id;
  final String nama;
  final String email;
  final String tahunAngkatan;
  final String alamat;
  final String nis;
  final String nisn;
  final String? namaUsaha;
  final String? nomorTelepon;
  final String? linkWebUsaha;

  Alumni({
    required this.id,
    required this.nama,
    required this.email,
    required this.tahunAngkatan,
    required this.alamat,
    required this.nis,
    required this.nisn,
    this.namaUsaha,
    this.nomorTelepon,
    this.linkWebUsaha,
  });

  // Fungsi untuk mengonversi JSON ke model Alumni
  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      tahunAngkatan: json['tahun_angkatan'].toString(),
      alamat: json['alamat'],
      nis: json['nis'],
      nisn: json['nisn'],
      namaUsaha: json['nama_usaha'],
      nomorTelepon: json['nomor_telepon'],
      linkWebUsaha: json['link_web_usaha'],
    );
  }

  // Fungsi untuk mengonversi model Alumni menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'tahun_angkatan': tahunAngkatan,
      'alamat': alamat,
      'nis': nis,
      'nisn': nisn,
      'nama_usaha': namaUsaha,
      'nomor_telepon': nomorTelepon,
      'link_web_usaha': linkWebUsaha,
    };
  }
}
