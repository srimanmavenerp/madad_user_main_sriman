class VehicleModel {
  final String id;
  final String brand;
  final String model;

  VehicleModel({required this.id, required this.brand, required this.model});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
      };
}