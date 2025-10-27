class TypesOfCarWash {
  bool? success;
  String? categoryId;
  List<new_Service>? services;

  TypesOfCarWash({this.success, this.categoryId, this.services});

  TypesOfCarWash.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    categoryId = json['category_id'];
    if (json['services'] != null) {
      services = List<new_Service>.from(
        json['services'].map((v) => new_Service.fromJson(v)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['category_id'] = categoryId;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class new_Service {
  String? id;
  String? name;
  String? shortDescription;
  String? description;
  String? coverImage;
  String? thumbnail;
  String? categoryId;
  String? subCategoryId;
  int? tax;
  int? orderCount;
  int? isActive;
  int? ratingCount;
  int? avgRating;
  String? minBiddingPrice;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? thumbnailFullPath;
  String? coverImageFullPath;
  List<Translation>? translations;
  dynamic storageThumbnail;
  dynamic storageCoverImage;

  new_Service({
    this.id,
    this.name,
    this.shortDescription,
    this.description,
    this.coverImage,
    this.thumbnail,
    this.categoryId,
    this.subCategoryId,
    this.tax,
    this.orderCount,
    this.isActive,
    this.ratingCount,
    this.avgRating,
    this.minBiddingPrice,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.thumbnailFullPath,
    this.coverImageFullPath,
    this.translations,
    this.storageThumbnail,
    this.storageCoverImage,
  });

  new_Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    description = json['description'];
    coverImage = json['cover_image'];
    thumbnail = json['thumbnail'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    tax = json['tax'];
    orderCount = json['order_count'];
    isActive = json['is_active'];
    ratingCount = json['rating_count'];
    avgRating = json['avg_rating'];
    minBiddingPrice = json['min_bidding_price'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailFullPath = json['thumbnail_full_path'];
    coverImageFullPath = json['cover_image_full_path'];
    if (json['translations'] != null) {
      translations = List<Translation>.from(
        json['translations'].map((v) => Translation.fromJson(v)),
      );
    }
    storageThumbnail = json['storage_thumbnail'];
    storageCoverImage = json['storage_cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['cover_image'] = coverImage;
    data['thumbnail'] = thumbnail;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['tax'] = tax;
    data['order_count'] = orderCount;
    data['is_active'] = isActive;
    data['rating_count'] = ratingCount;
    data['avg_rating'] = avgRating;
    data['min_bidding_price'] = minBiddingPrice;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['thumbnail_full_path'] = thumbnailFullPath;
    data['cover_image_full_path'] = coverImageFullPath;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['storage_thumbnail'] = storageThumbnail;
    data['storage_cover_image'] = storageCoverImage;
    return data;
  }
}

class Translation {
  int? id;
  String? translationableType;
  String? translationableId;
  String? locale;
  String? key;
  String? value;

  Translation({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
  });

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
