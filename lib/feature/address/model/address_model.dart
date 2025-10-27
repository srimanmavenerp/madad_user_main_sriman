class AddressModel {
  String? id;
  String? addressLabel;
  String? addressType;
  String? userId;
  String? address;
  String? latitude;
  String? longitude;
  String? city;
  String? zipCode;
  String? country;
  String? zoneId;
  String? method;
  String? contactPersonName;
  String? contactPersonNumber;
  String? contactPersonLabel;
  String? street;
  String? house;
  String? floor;
  int? availableServiceCountInZone;
  bool? hasParkingLot;
  String? parkingDetails;
  String? parkingLotType; // (optional) like underground, surface, etc.
  String? parkingSpotNumber; // (optional)
  bool? isParkingFree; // (optional)
  double? parkingFee; // (optional)
  String? parkingTimeLimit; //

  AddressModel(
      {this.id,
        this.addressType,
        this.addressLabel,
        this.userId,
        this.address,
        this.latitude,
        this.longitude,
        this.city,
        this.zipCode,
        this.country,
        this.zoneId,
        this.method,
        this.contactPersonName,
        this.contactPersonNumber,
        this.contactPersonLabel,
        this.street,
        this.house,
        this.floor,
        this.availableServiceCountInZone,
        this.hasParkingLot = false,
        this.parkingDetails,
        this.parkingLotType,
        this.parkingSpotNumber,
        this.isParkingFree,
        this.parkingFee,
        this.parkingTimeLimit
      });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    addressType = json['address_type'];
    addressLabel = json['address_label'];
    latitude = json['lat'];
    longitude = json['lon'];
    city = json['city'];
    zipCode = json['zip_code'];
    country = json['country'];
    zoneId = json['zone_id'];
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    contactPersonLabel = json['address_label'];
    street = json['street'];
    house = json['house'];
    floor = json['floor'];
    availableServiceCountInZone = json['available_service_count'];
    hasParkingLot = json['has_parking_lot'] ?? false;
    parkingDetails = json['parking_details'];
    parkingLotType = json['parking_lot_type'];
    parkingSpotNumber = json['parking_spot_number'];
    isParkingFree = json['is_parking_free'] ?? false;
    parkingFee = json['parking_fee']?.toDouble();
    parkingTimeLimit = json['parking_time_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['address_label'] = addressLabel;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['lat'] = latitude;
    data['lon'] = longitude;
    data['city'] = city;
    data['zip_code'] = zipCode;
    data['country'] = country;
    data['zone_id'] = zoneId;
    data['address_label'] = addressLabel;
    data['contact_person_name'] = contactPersonName;
    data['_method'] = method;
    data['street'] = street;
    data['house'] = house;
    data['floor'] = floor;
    data['available_service_count'] = availableServiceCountInZone;
    data['has_parking_lot'] = hasParkingLot;
    data['parking_details'] = parkingDetails;
    data['parking_lot_type'] = parkingLotType;
    data['parking_spot_number'] = parkingSpotNumber;
    data['is_parking_free'] = isParkingFree;
    data['parking_fee'] = parkingFee;
    data['parking_time_limit'] = parkingTimeLimit;
    return data;
  }
}