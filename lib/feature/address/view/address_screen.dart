


import 'package:get/get.dart';
import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';

class AddressScreen extends StatefulWidget {
  final String? fromPage;

  const AddressScreen({super.key, this.fromPage});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();

    // Fetch address list
    Get.find<LocationController>().getAddressList(
      fromCheckout: widget.fromPage == "checkout" ? true : false,
    );

    // Set default selected address from controller
    final AddressModel? userAddress = Get.find<LocationController>().getUserAddress();
    _selectedAddressId = userAddress?.id?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'my_address'.tr),
      endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,

      body: GetBuilder<LocationController>(builder: (locationController) {
        List<AddressModel>? addressList = locationController.addressList;
        List<AddressModel> zoneBasedAddress = [];

        // Filter zone-based address for checkout
        if (addressList != null && addressList.isNotEmpty) {
          zoneBasedAddress = addressList
              .where((element) =>
          element.zoneId ==
              Get.find<LocationController>().getUserAddress()?.zoneId)
              .toList();
        }

        if (widget.fromPage == "checkout") {
          addressList = zoneBasedAddress;
        }

        if (addressList != null) {
          return FooterBaseView(
            isCenter: addressList.isEmpty,
            child: WebShadowWrap(
              child: Column(
                children: [
                  if (ResponsiveHelper.isDesktop(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          width: 200,
                          buttonText: 'add_new_address'.tr,
                          onPressed: () {
                            Get.toNamed(RouteHelper.getAddAddressRoute(
                                widget.fromPage == 'checkout'));
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  addressList.isNotEmpty
                      ? RefreshIndicator(
                    onRefresh: () async {
                      await locationController.getAddressList();
                    },
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                          childAspectRatio: ResponsiveHelper.isMobile(context) ? 4 : 6,
                          crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
                          mainAxisExtent: Dimensions.addressItemHeight,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ||
                              ResponsiveHelper.isTab(context)
                              ? Dimensions.paddingSizeExtraLarge
                              : 2.0,
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemCount: addressList.length,
                        itemBuilder: (context, index) {
                          AddressModel address = addressList![index];

                          return AddressWidget(
                            selectedUserAddressId: _selectedAddressId,
                            address: address,
                            fromAddress: true,
                            fromCheckout: widget.fromPage == 'checkout',
                            onTap: () async {
                              setState(() {
                                _selectedAddressId = address.id?.toString();
                              });

                              // Handle checkout selection logic
                              if (widget.fromPage == 'checkout') {
                                if (isRedundentClick(DateTime.now())) return;

                                Get.dialog(const CustomLoader(), barrierDismissible: false);

                                await locationController
                                    .setAddressIndex(address)
                                    .then((isSuccess) {
                                  Get.back();
                                  if (!isSuccess) {
                                   showCustomSnackbar(
  title: 'Info',
  message: 'this_service_not_available'.tr,
  type: SnackbarType.info, // sets blue background and info icon automatically
  position: SnackPosition.BOTTOM,
  duration: const Duration(seconds: 3),
);

                                  }
                                });

                                Get.back();
                              }
                            },
                            onEditPressed: () {
                              Get.toNamed(RouteHelper.getEditAddressRoute(address, false));
                            },
                            onRemovePressed: () {
                              if (Get.isSnackbarOpen) {
                                Get.back();
                              }
                              Get.dialog(
                                ConfirmationDialog(
                                  icon: Images.warning,
                                  description: 'are_you_sure_want_to_delete_address'.tr,
                                  onYesPressed: () {
                                    Navigator.of(context).pop();

                                    Get.dialog(
                                      const CustomLoader(),
                                      barrierDismissible: false,
                                    );

                                    locationController
                                        .deleteUserAddressByID(address)
                                        .then((response) {
                                      Get.back();
                                      customSnackBar(
                                        response.message!.tr.capitalizeFirst,
                                        type: ToasterMessageType.success,
                                      );
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                      : SizedBox(
                    height: Get.height * 0.6,
                    child: Center(
                      child: NoDataScreen(
                        text: 'no_address_found'.tr,
                        type: NoDataType.address,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),

      floatingActionButton:
      (!ResponsiveHelper.isDesktop(context) && Get.find<AuthController>().isLoggedIn())
          ? GestureDetector(
        onTap: () {
          Get.toNamed(RouteHelper.getAddAddressRoute(
              widget.fromPage == 'checkout'));
        },
        child: Container(
          height: Dimensions.addAddressHeight,
          width: Dimensions.addAddressWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
            boxShadow: Get.isDarkMode ? null : shadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 20),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                'add_new_address'.tr,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}