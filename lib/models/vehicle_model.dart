class VehicleModel {
  final int id;
  final String fipeCode;
  final String model;
  final String years;

  VehicleModel({
    required this.id,
    required this.fipeCode,
    required this.model,
    required this.years,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      fipeCode: json['fipe_code'],
      model: json['model'],
      years: json['years'],
    );
  }
}
