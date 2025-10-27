class CartModelBody {
  String? serviceId;
  String? categoryId;
  String? variantKey;
  String? quantity;
  String? subCategoryId;
  String? providerId;
  String? guestId;
  String? contact_no;
  String? additional_details;

  CartModelBody({this.serviceId, this.categoryId, this.variantKey, this.quantity, this.subCategoryId, this.providerId, this.guestId,this.contact_no, this.additional_details,});

  CartModelBody.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    categoryId = json['category_id'];
    variantKey = json['variant_key'];
    quantity = json['quantity'];
    subCategoryId = json['sub_category_id'];
    providerId = json['provider_id'];
    guestId = json['guest_id'];
    contact_no = json['contact_no'];
    additional_details = json['additional_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['category_id'] = categoryId;
    data['variant_key'] = variantKey;
    data['quantity'] = quantity;
    data['sub_category_id'] = subCategoryId;
    if(providerId!=null){
      data['provider_id'] = providerId;
    }
    if(guestId!=null){
      data['guest_id'] = guestId;
    }
    if(contact_no!=null){
      data['contact_no'] = contact_no;
    }
    if(additional_details!=null){
      data['additional_details'] = additional_details;
    }
    return data;
  }
}