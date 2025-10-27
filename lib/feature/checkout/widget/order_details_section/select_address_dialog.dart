import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class SelectAddressDialog extends StatefulWidget {
  final List<AddressModel> addressList;
  final String? selectedAddressId;
  const SelectAddressDialog(
      {super.key, required this.addressList, this.selectedAddressId});

  @override
  State<SelectAddressDialog> createState() => _SelectAddressDialogState();
}

class _SelectAddressDialogState extends State<SelectAddressDialog> {
  List<AddressModel> addressList = [];
  @override
  void initState() {
    super.initState();
    for (var element in widget.addressList) {
      if (element.zoneId ==
          Get.find<LocationController>().getUserAddress()?.zoneId) {
        addressList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return SizedBox(
        width: Dimensions.webMaxWidth / 2.3,
        height: MediaQuery.of(context).size.height * .4,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeLarge,
              horizontal: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : Dimensions.paddingSizeLarge),
          child: Scaffold(
            body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(),
                  Text(
                    "please_select_an_address".tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge + 2),
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeSmall,
                  ),
                  Text(
                    "where_you_want_to_take_the_service".tr,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeLarge,
                  ),
                  addressList.isNotEmpty
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                AddressModel? addressModel =
                                    CheckoutHelper.selectedAddressModel(
                                        selectedAddress:
                                            Get.find<LocationController>()
                                                .selectedAddress,
                                        pickedAddress:
                                            Get.find<LocationController>()
                                                .getUserAddress());
                                Get.back();
                                Get.toNamed(RouteHelper.getEditAddressRoute(
                                    addressModel ?? AddressModel(), true));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeSmall,
                                  ),
                                  Text(
                                    'use_my_current_location'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )
                                ],
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: Get.height * 0.4, minHeight: 100),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeLarge),
                                itemCount: addressList.length,
                                itemBuilder: (context, index) {
                                  return GetBuilder<CheckOutController>(
                                      builder: (controller) {
                                    return AddressWidget(
                                      address: addressList[index],
                                      fromCheckout: true,
                                      fromAddress: false,
                                      isShowOnlyEdit: false,
                                      onEditPressed: () {
                                        Get.back();
                                        Get.toNamed(
                                            RouteHelper.getEditAddressRoute(
                                                addressList[index], true));
                                      },
                                      onTap: () {
                                        locationController
                                            .updateSelectedAddress(
                                                addressList[index]);
                                        Get.back();
                                      },
                                      selectedUserAddressId:
                                          widget.selectedAddressId,
                                    );
                                  });
                                },
                              ),
                            ),
                            CustomButton(
                              buttonText: "add_new_address".tr,
                              icon: Icons.add_circle_outline_sharp,
                              backgroundColor: Colors.transparent,
                              transparent: true,
                              onPressed: () {
                                Get.back();
                                Get.toNamed(
                                    RouteHelper.getAddAddressRoute(true));
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Center(
                                child: Image.asset(
                              Images.emptyAddress,
                              width: 160,
                            )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraLarge,
                                  vertical: Dimensions.paddingSizeDefault),
                              child: Text(
                                "you_don't_have_any_address_yet_please_add_address"
                                    .tr,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall + 1,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withValues(alpha: 0.4)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.paddingSizeExtraLarge * 1.5),
                              child: CustomButton(
                                buttonText: "add_new_address".tr,
                                icon: Icons.add_circle_outline_sharp,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 45
                                    : 40,
                                radius: Dimensions.radiusDefault,
                                onPressed: () {
                                  Get.back();
                                  Get.toNamed(
                                      RouteHelper.getAddAddressRoute(true));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.paddingSizeExtraLarge * 1.5),
                              child: CustomButton(
                                buttonText: "use_my_current_location".tr,
                                icon: Icons.my_location,
                                backgroundColor: Colors.transparent,
                                transparent: true,
                                onPressed: () {
                                  AddressModel? addressModel =
                                      CheckoutHelper.selectedAddressModel(
                                          selectedAddress:
                                              Get.find<LocationController>()
                                                  .selectedAddress,
                                          pickedAddress:
                                              Get.find<LocationController>()
                                                  .getUserAddress());
                                  Get.back();
                                  Get.toNamed(RouteHelper.getEditAddressRoute(
                                      addressModel ?? AddressModel(), true));
                                },
                              ),
                            ),
                          ],
                        ),
                ]),
          ),
        ),
      );
    });
  }
}
