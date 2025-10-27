import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class ApiChecker {
  static void checkApi(Response response, {bool showDefaultToaster = true}) {


  if (response.statusCode == 401) {
  Get.find<AuthController>().clearSharedData(response: response);
  if (Get.currentRoute != RouteHelper.getInitialRoute()) {
    Get.offAllNamed(RouteHelper.getInitialRoute());
    showCustomSnackbar(
      title: 'Unauthorized',
      message: "${response.statusCode}",
      type: SnackbarType.error,
      position: SnackPosition.BOTTOM,
    );
  }
} else if (response.statusCode == 500) {
  showCustomSnackbar(
    title: 'Server Error',
    message: "${response.statusCode}",
    type: SnackbarType.error,
    position: SnackPosition.BOTTOM,
  );
} else if (response.statusCode == 400 && response.body['errors'] != null) {
  showCustomSnackbar(
    title: 'Error',
    message: "${response.body['errors'][0]['message']}",
    type: SnackbarType.error,
    position: SnackPosition.BOTTOM,
  );
} else if (response.statusCode == 429) {
  showCustomSnackbar(
    title: 'Too Many Requests',
    message: "too_many_request".tr,
    type: SnackbarType.warning,
    position: SnackPosition.BOTTOM,
  );
} else {
  showCustomSnackbar(
    title: 'Error',
    message: "${response.body['message']}",
    type: SnackbarType.error,
    position: SnackPosition.BOTTOM,
  );
}

  }
}