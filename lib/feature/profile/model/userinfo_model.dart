import 'package:madaduser/feature/booking/model/booking_details_model.dart';

class UserInfoModel {
  String? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? imageFullPath;
  String? phone;
  String? password;
  String? confirmPassword;
  String? createdAt;
  int? bookingsCount;
  String? referCode;
  String? referredBy;
  int? isEmailVerified;
  int? isPhoneVerified;
  double? walletBalance;
  BookingDetailsContent? lastIncompleteOfflineBooking;
  bool? corporateUser;




  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.imageFullPath,
        this.phone,
        this.password,
        this.confirmPassword,
        this.createdAt,
        this.bookingsCount,
        this.referCode,
        this.referredBy,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.walletBalance,
        this.lastIncompleteOfflineBooking,
        this.corporateUser,


      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['first_name'];
    lName = json['last_name'];
    email = json['email'];
    image = json['profile_image'];
    imageFullPath = json['profile_image_full_path'];
    phone = json['phone'];
    createdAt = json['created_at'];
    referCode = json['ref_code'];
    referredBy = json['referred_by'];
    bookingsCount =  int.tryParse(json['bookings_count'].toString());
    isEmailVerified =  int.tryParse(json['is_email_verified'].toString());
    isPhoneVerified =  int.tryParse(json['is_phone_verified'].toString());
    walletBalance =  double.tryParse(json['wallet_balance'].toString());
    lastIncompleteOfflineBooking = json['last_incomplete_offline_booking'] != null
        ? BookingDetailsContent.fromJson(json['last_incomplete_offline_booking'])
        : null;

    corporateUser = json['corporate_user'] == true;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = fName;
    data['last_name'] = lName;
    data['email'] = email;
    data['profile_image'] = image;
    data['profile_image_full_path'] = imageFullPath;
    data['phone'] = phone;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['ref_code'] = referCode;
    data['referred_by'] = referredBy;

    data['corporate_user'] = corporateUser;

    return data;
  }
}