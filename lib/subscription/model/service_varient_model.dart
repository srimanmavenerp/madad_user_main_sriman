// class ServiceVariantModel {
//   final int id;
//   final String variant;
//   final String variantKey;
//   final String vehicleType;
//   final String serviceId;
//   final String zoneId;
//   final double price;
//
//   ServiceVariantModel({
//     required this.id,
//     required this.variant,
//     required this.variantKey,
//     required this.vehicleType,
//     required this.serviceId,
//     required this.zoneId,
//     required this.price,
//   });
//
//   factory ServiceVariantModel.fromJson(Map<String, dynamic> json) {
//     return ServiceVariantModel(
//       id: json['id'],
//       variant: json['variant'],
//       variantKey: json['variant_key'],
//       vehicleType: json['vehicle_type'],
//       serviceId: json['service_id'],
//       zoneId: json['zone_id'],
//       price: (json['price'] as num).toDouble(),
//     );
//   }
// }
//


class ServiceVariantResponse {
  final bool success;
  final List<ServicePackage> data;

  ServiceVariantResponse({
    required this.success,
    required this.data,
  });

  factory ServiceVariantResponse.fromJson(Map<String, dynamic> json) {
    return ServiceVariantResponse(
      success: json['success'],
      data: (json['data'] as List<dynamic>)
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ServicePackage {
  final String packageName;
  final String description;
  final List<ServiceVariantModel> variantOptions;

  ServicePackage({
    required this.packageName,
    required this.variantOptions,
    required this.description,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      packageName: json['package_name'],
      description: json['package_description'] ?? '',
      variantOptions: (json['variant_options'] as List<dynamic>)
          .map((e) => ServiceVariantModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_name': packageName,
      'variant_options': variantOptions.map((e) => e.toJson()).toList(),
      'package_description': description,
    };
  }
}

class ServiceVariantModel {
  final int id;
  final String variant;
  final String variantKey;
  final String vehicleType;
  final String serviceId;
  final String zoneId;
  final double price;

  ServiceVariantModel({
    required this.id,
    required this.variant,
    required this.variantKey,
    required this.vehicleType,
    required this.serviceId,
    required this.zoneId,
    required this.price,
  });

  factory ServiceVariantModel.fromJson(Map<String, dynamic> json) {
    return ServiceVariantModel(
      id: json['id'] ?? 0,
      variant: json['variant'] ?? '',
      variantKey: json['variant_key'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      serviceId: json['service_id'] ?? '',
      zoneId: json['zone_id'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant': variant,
      'variant_key': variantKey,
      'vehicle_type': vehicleType,
      'service_id': serviceId,
      'zone_id': zoneId,
      'price': price,
    };
  }

  // ✅ Add equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServiceVariantModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Optional: for better debugging/logging
  @override
  String toString() => 'ServiceVariantModel(id: $id, variant: $variant)';
}
