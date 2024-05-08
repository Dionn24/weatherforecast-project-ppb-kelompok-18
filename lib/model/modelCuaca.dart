class ModelCuaca {
  final String? jamCuaca;
  final String? kodeCuaca;
  final String? cuaca;
  final String? humidity;
  final String? tempC;
  final String? tempF;

  ModelCuaca({
    this.jamCuaca,
    this.kodeCuaca,
    this.cuaca,
    this.humidity,
    this.tempC,
    this.tempF,
  });

  ModelCuaca.fromJson(Map<String, dynamic> json)
      : jamCuaca = json['jamCuaca'] as String?,
        kodeCuaca = json['kodeCuaca'] as String?,
        cuaca = json['cuaca'] as String?,
        humidity = json['humidity'] as String?,
        tempC = json['tempC'] as String?,
        tempF = json['tempF'] as String?;

  Map<String, dynamic> toJson() => {
    'jamCuaca' : jamCuaca,
    'kodeCuaca' : kodeCuaca,
    'cuaca' : cuaca,
    'humidity' : humidity,
    'tempC' : tempC,
    'tempF' : tempF
  };
}