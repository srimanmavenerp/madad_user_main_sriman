import 'package:madaduser/api/remote/client_api.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/app_constants.dart';

class ScheduleRepo extends GetxService {
  final ApiClient apiClient;
  ScheduleRepo({required this.apiClient});

Future<Response> changePostScheduleTime(String postId, String scheduleTime, String slot) async {
  return await apiClient.postData(AppConstants.updatePostInfo, {
    "_method": "put",
    "post_id": postId,
    "booking_schedule": scheduleTime,
    "slot": slot,
  });
}

}