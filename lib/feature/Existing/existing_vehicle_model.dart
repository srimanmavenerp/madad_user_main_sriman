class VehicleSessionModel {
  final bool status;
  final String message;
  final VehicleSessionData? data;

  VehicleSessionModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory VehicleSessionModel.fromJson(Map<String, dynamic> json) {
    return VehicleSessionModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VehicleSessionData.fromJson(json['data']) : null,
    );
  }
}

class VehicleSessionData {
  final String userId;
  final String vehicleId;
  final String updatedAt;
  final String createdAt;
  final int id;

  VehicleSessionData({
    required this.userId,
    required this.vehicleId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory VehicleSessionData.fromJson(Map<String, dynamic> json) {
    return VehicleSessionData(
      userId: json['user_id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}
