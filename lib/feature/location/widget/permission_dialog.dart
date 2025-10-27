import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded, color: Colors.deepPurple, size: 100),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              ResponsiveHelper.isMobilePhone() ? 'you_denied_location_permission'.tr : "please_enable_location_permission_from_browser_settings".tr,
              textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: Text('close'.tr),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              if(!kIsWeb)
              const SizedBox(width: Dimensions.paddingSizeSmall),
              if(!kIsWeb)
              Expanded(child: CustomButton(buttonText: 'settings'.tr, onPressed: () async {
                await Geolocator.openAppSettings();
                Navigator.pop(Get.context!);
              })),
            ]),
          ]),
        ),
      ),
    );
  }
}
