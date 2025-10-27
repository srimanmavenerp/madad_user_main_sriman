import 'package:get/get.dart';
import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';

class UpdateScreen extends StatelessWidget {
  final String? fromPage;

  const UpdateScreen({super.key,this.fromPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fromPage == null ? const NotFoundScreen() : Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              fromPage == "update" ? Images.update : Images.maintenance,
              width: Dimensions.logoSize,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
            ),

            Text(
              fromPage == "update"  ? 'update_is_available'.tr : 'we_are_under_maintenance'.tr,
              style: robotoBold.copyWith(fontSize: MediaQuery
                  .of(context)
                  .size
                  .height * 0.023, color: Theme
                  .of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.02),

            Text(
              fromPage == "update"  ? 'your_app_needs_to_update'.tr : 'we_will_be_right_back'
                  .tr,
              style: robotoRegular.copyWith(fontSize: MediaQuery
                  .of(context)
                  .size
                  .height * 0.0175, color: Theme
                  .of(context)
                  .disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:fromPage == "update"  ? MediaQuery
                .of(context)
                .size
                .height * 0.03 : 0),

            fromPage == "update"  ? CustomButton(
                buttonText: 'update_now'.tr, onPressed: () async {
              String appUrl = 'https://google.com';
              if (GetPlatform.isAndroid) {
                appUrl = Get
                    .find<SplashController>()
                    .configModel
                    .content!
                    .appUrlAndroid!;
              } else if (GetPlatform.isIOS) {
                appUrl = Get
                    .find<SplashController>()
                    .configModel
                    .content!
                    .appUrlIos!;
              }

              _launchUrl(Uri.parse(appUrl));

              if (await launchUrl(Uri.parse(appUrl))) {
                launchUrl(Uri.parse(appUrl));
              } else {
                showCustomSnackbar(
  title: 'Error',
  message: '${'can_not_launch'.tr} $appUrl',
  type: SnackbarType.error, // automatically sets red background and error icon
  position: SnackPosition.BOTTOM,
  duration: const Duration(seconds: 3),
);

              }
            }) : const SizedBox(),

          ]),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}