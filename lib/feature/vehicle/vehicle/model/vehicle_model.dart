class VehicleModel {
  final String id;
  final String brand;
  late final String type;
  final String model;
  final String color;
  String contact_no;
  String additional_details;
  final String vehicleNo; // <-- Use vehicleNo instead of number

  VehicleModel({
    required this.id,
    required this.brand,
    required this.type,
    required this.model,
    required this.color,
    required this.contact_no,
    required this.additional_details,
    required this.vehicleNo, required String userId,

  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'].toString(),
      brand: json['brand'].toString(),
      type: json['type'].toString(),
      model: json['model'].toString(),
      color: json['color'].toString(),
      contact_no: json['contact_no'].toString(),
      additional_details: json['additional_details'].toString(),
      vehicleNo: json['vehicle_no'].toString(),
      userId: json['user_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'type': type,
    'model': model,
    'contact_no': contact_no,
    'additional_details': additional_details,
    'color': color,
    'vehicle_no': vehicleNo, // <-- Match API field
  };
}