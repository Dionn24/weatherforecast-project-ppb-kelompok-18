class ModelDaerah {
  final String? id;
  final String? propinsi;
  final String? kota;
  final String? kecamatan;
  final String? lat;
  final String? lon;

  ModelDaerah({
    this.id,
    this.propinsi,
    this.kota,
    this.kecamatan,
    this.lat,
    this.lon,
  });

  ModelDaerah.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        propinsi = json['propinsi'] as String?,
        kota = json['kota'] as String?,
        kecamatan = json['kecamatan'] as String?,
        lat = json['lat'] as String?,
        lon = json['lon'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'propinsi' : propinsi,
    'kota' : kota,
    'kecamatan' : kecamatan,
    'lat' : lat,
    'lon' : lon
  };
}