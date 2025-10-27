import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:madaduser/utils/core_export.dart';

class PushNotificationDialog extends StatefulWidget {
  final String? title;
  final NotificationBody? notificationBody;
  const PushNotificationDialog({super.key, required this.title, required this.notificationBody});

  @override
  State<PushNotificationDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<PushNotificationDialog> {

  @override
  void initState() {
    super.initState();
    if(Get.find<AuthController>().isLoggedIn()){
      if(Get.find<AuthController>().isNotificationActive()){
        _startAlarm();
      }
    }
  }
  void _startAlarm() async {
    final player = AudioPlayer();
    player.play(AssetSource('notification.wav'));
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Container(
        width: Dimensions.pushNotificationDialogWidth,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),

        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active, size: 60, color: Theme.of(context).colorScheme.primary),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(
              children: [
                Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),),
                      child: Text(
                        'cancel'.tr,
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            )),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: CustomButton(
              height: 40,
              buttonText: 'go'.tr,
              onPressed: () {
                Get.back();

                if(widget.notificationBody?.notificationType == "booking" && widget.notificationBody?.bookingId != null && widget.notificationBody?.bookingId!=""){

                  if(widget.notificationBody?.bookingType == "repeat" && widget.notificationBody?.repeatBookingType == "single"){
                    Get.toNamed(RouteHelper.getBookingDetailsScreen( subBookingId : widget.notificationBody!.bookingId!,fromPage: 'fromNotification'));
                  }else if(widget.notificationBody?.bookingType == "repeat" && widget.notificationBody?.repeatBookingType != "single"){
                    Get.toNamed(RouteHelper.getRepeatBookingDetailsScreen( bookingId : widget.notificationBody!.bookingId, fromPage : "fromNotification"));
                  }else{
                    Get.toNamed(RouteHelper.getBookingDetailsScreen( bookingID:widget.notificationBody!.bookingId!,fromPage: 'fromNotification'));
                  }

                }

                else if(widget.notificationBody?.notificationType=="chatting"){

                  Get.toNamed(RouteHelper.getChatScreenRoute(
                    widget.notificationBody?.channelId??"",
                    widget.notificationBody?.userType == 'super-admin' ? "admin" : widget.notificationBody?.userName??"",
                    widget.notificationBody?.userProfileImage??"",
                    widget.notificationBody?.userPhone??"",
                    widget.notificationBody?.userType??"",
                    fromNotification: "fromNotification",
                  ));

                }

                else if(widget.notificationBody?.notificationType == 'privacy_policy' && widget.notificationBody?.title != null && widget.notificationBody!.title !=''){
                  Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
                }

                else if(widget.notificationBody?.notificationType == 'terms_and_conditions' && widget.notificationBody?.title != null && widget.notificationBody!.title !=''){
                  Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
                }
                else if(widget.notificationBody?.notificationType=="bidding") {
                  Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
                } else if(widget.notificationBody?.notificationType == "wallet"){
                  Get.toNamed(RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
                }
                else if(widget.notificationBody?.notificationType == "loyalty_point"){
                  Get.toNamed(RouteHelper.getLoyaltyPointScreen(fromNotification: "fromNotification"));
                }
                else if(widget.notificationBody?.notificationType == "bid-withdraw"){
                  Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: 'fromNotification'));
                }
                else{
                  Get.toNamed(RouteHelper.getNotificationRoute());
                }
              }),
            ),
          ]),

        ]),
      ),
    );
  }
}
