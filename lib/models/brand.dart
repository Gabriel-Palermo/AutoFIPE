class Brand {
  final int id;
  final String brand;

  Brand({required this.id, required this.brand});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], brand: json['brand']);
  }
}
