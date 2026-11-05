class VehicleYear {
  final String yearId;
  final String modelYear;
  final String fuel;
  final int price;

  VehicleYear({
    required this.yearId,
    required this.modelYear,
    required this.fuel,
    required this.price,
  });

  factory VehicleYear.fromJson(Map<String, dynamic> json) {
    return VehicleYear(
      yearId: json['year_id'],
      modelYear: json['model_year'],
      fuel: json['fuel'],
      price: json['price'],
    );
  }
}
