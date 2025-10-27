class AutoCareServiceModel {
  final bool? success;
  final List<Data>? data;

  AutoCareServiceModel({this.success, this.data});

  factory AutoCareServiceModel.fromJson(Map<String, dynamic> json) {
    return AutoCareServiceModel(
      success: json['success'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  final String? packageName;
  final int? packageId;
  final List<VariantOptions>? variantOptions;

  Data({this.packageName, this.packageId, this.variantOptions});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      packageName: json['package_name'],
      packageId: json['package_id'],
      variantOptions: json['variant_options'] != null
          ? List<VariantOptions>.from(
          json['variant_options'].map((v) => VariantOptions.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_name': packageName,
      'package_id': packageId,
      'variant_options': variantOptions?.map((v) => v.toJson()).toList(),
    };
  }
}

class VariantOptions {
  final int? id;
  final String? variant;
  final dynamic vehicleType; // Use dynamic to allow null or other types
  final String? variantKey;
  final int? packageId;
  final String? serviceId;
  final String? zoneId;
  final int? price;
  final String? createdAt;
  final String? updatedAt;

  VariantOptions({
    this.id,
    this.variant,
    this.vehicleType,
    this.variantKey,
    this.packageId,
    this.serviceId,
    this.zoneId,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory VariantOptions.fromJson(Map<String, dynamic> json) {
    return VariantOptions(
      id: json['id'],
      variant: json['variant'],
      vehicleType: json['vehicle_type'],
      variantKey: json['variant_key'],
      packageId: json['package_id'],
      serviceId: json['service_id'],
      zoneId: json['zone_id'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant': variant,
      'vehicle_type': vehicleType,
      'variant_key': variantKey,
      'package_id': packageId,
      'service_id': serviceId,
      'zone_id': zoneId,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
