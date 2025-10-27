import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class SubmitReviewRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  SubmitReviewRepo({required this.sharedPreferences,required this.apiClient});

  Future<Response> submitReview({required ReviewBody reviewBody}) async {
    return await apiClient.postData(AppConstants.serviceReview, reviewBody.toJson());
  }
  Future<Response> getReviewList({required String bookingId}) async {
    return await apiClient.getData('${AppConstants.bookingReviewList}?booking_id=$bookingId');
  }
}