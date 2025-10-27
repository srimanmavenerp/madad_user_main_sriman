class ExistingVehicleDetails {
  final bool status;
  final String message;
  final VehicleData data;

  ExistingVehicleDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExistingVehicleDetails.fromJson(Map<String, dynamic> json) {
    return ExistingVehicleDetails(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: VehicleData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class VehicleData {
  final int id;
  final String userId;
  final String brand;
  final String type;
  final String model;
  final String color;
  final String vehicleNo;
  final String createdAt;
  final String updatedAt;

  VehicleData({
    required this.id,
    required this.userId,
    required this.brand,
    required this.type,
    required this.model,
    required this.color,
    required this.vehicleNo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id'],
      userId: json['user_id'],
      brand: json['brand'],
      type: json['type'],
      model: json['model'],
      color: json['color'],
      vehicleNo: json['vehicle_no'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'brand': brand,
      'type': type,
      'model': model,
      'color': color,
      'vehicle_no': vehicleNo,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}