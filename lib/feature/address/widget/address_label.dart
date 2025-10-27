import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class AddressLabelWidget extends StatelessWidget {
  const AddressLabelWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController){
        return Center(
          child: SizedBox(
            width:ResponsiveHelper.isMobile(context) ?null :ResponsiveHelper.isWeb() ? Get.width / 2 : 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'label_as'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: AddressLabel.values.map((label) => InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      locationController.updateAddressLabel(addressLabel: label);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        border: Border.all(color: label == locationController.selectedAddressLabel ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor,
                        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                      ),
                      child: Row(children: [
                        Icon(
                          label.index  == 0 ? Icons.home_filled : label.index == 1 ? Icons.work : Icons.location_on,
                          color: label == locationController.selectedAddressLabel ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          label.name.tr,
                          style: robotoRegular.copyWith(color: label == locationController.selectedAddressLabel ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
                        ),
                      ]),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
