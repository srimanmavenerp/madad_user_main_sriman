import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool? fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen({
    super.key,
    required this.fromSignUp,
    required this.route,
    this.fromHome = false,
  });

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool isLoggedIn = false;
  AddressModel? _addressModel;

  @override
  void initState() {
    super.initState();

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);

    isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
    _addressModel = Get.find<LocationController>().getUserAddress();
  }

  final shakeKey = GlobalKey<CustomShakingWidgetState>();

  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: () {
        if (_canExit) {
          if (!GetPlatform.isWeb) {
            exit(0);
          }
        } else {
          customSnackBar(
            'back_press_again_to_exit'.tr,
            type: ToasterMessageType.info,
          );
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: CustomAppBar(
          title: 'set_location'.tr,
          isBackButtonExist: false,
          shakeKey: shakeKey,
        ),
        body: SafeArea(
          child: Center(
            child: GetBuilder<LocationController>(
              builder: (locationController) {
                return (ResponsiveHelper.isDesktop(context)) && !widget.fromHome
                    ? WebLandingPage(
                        fromSignUp: widget.fromSignUp,
                        route: widget.route,
                        shakeKey: shakeKey,
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: FooterBaseView(
                              isCenter:
                                  (!isLoggedIn ||
                                  locationController.addressList == null ||
                                  locationController.addressList!.isEmpty),
                              child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: WebShadowWrap(
                                  child: isLoggedIn
                                      ? Padding(
                                          padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeLarge,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              locationController.addressList !=
                                                      null
                                                  ? locationController
                                                            .addressList!
                                                            .isNotEmpty
                                                        ? ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                locationController
                                                                    .addressList!
                                                                    .length,
                                                            itemBuilder: (context, index) {
                                                              return Center(
                                                                child: SizedBox(
                                                                  width: 700,
                                                                  child: AddressWidget(
                                                                    address:
                                                                        locationController
                                                                            .addressList![index],
                                                                    fromAddress:
                                                                        false,
                                                                    onTap: () async {
                                                                      Get.dialog(
                                                                        const CustomLoader(),
                                                                        barrierDismissible:
                                                                            false,
                                                                      );
                                                                      AddressModel
                                                                      address =
                                                                          locationController
                                                                              .addressList![index];
                                                                      await locationController.setAddressIndex(
                                                                        address,
                                                                        fromAddressScreen:
                                                                            false,
                                                                      );

                                                                      // Navigate based on route
                                                                      locationController.saveAddressAndNavigate(
                                                                        address,
                                                                        widget
                                                                            .fromSignUp!,
                                                                        (widget.route ??
                                                                                RouteHelper.getVehicleSelectViewRoute(
                                                                                  serviceId: '',
                                                                                  subCategoryId: '',
                                                                                  categoryId: '',
                                                                                ))
                                                                            as String?,
                                                                        widget.route !=
                                                                            null,
                                                                        true,
                                                                      );
                                                                    },
                                                                    selectedUserAddressId:
                                                                        locationController
                                                                            .getUserAddress()!
                                                                            .id,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : NoDataScreen(
                                                            text:
                                                                'no_saved_address_found'
                                                                    .tr,
                                                            type: NoDataType
                                                                .address,
                                                          )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                              const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraLarge,
                                              ),
                                              if (ResponsiveHelper.isDesktop(
                                                context,
                                              ))
                                                BottomButton(
                                                  locationController:
                                                      locationController,
                                                  fromSignUp:
                                                      widget.fromSignUp!,
                                                  route: widget.route,
                                                ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Center(
                                              child: SizedBox(
                                                width: 700,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      Images.mapLocation,
                                                      height: 240,
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    Text(
                                                      'find_services_near_you'
                                                          .tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraLarge,
                                                        color: Get.isDarkMode
                                                            ? Theme.of(
                                                                context,
                                                              ).primaryColorLight
                                                            : Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            Dimensions
                                                                .paddingSizeLarge,
                                                          ),
                                                      child: Text(
                                                        'please_select_you_location_to_start_exploring_available_services_near_you'
                                                            .tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Get.isDarkMode
                                                              ? Theme.of(
                                                                  context,
                                                                ).primaryColorLight
                                                              : Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge,
                                                    ),
                                                    if (ResponsiveHelper.isDesktop(
                                                      context,
                                                    ))
                                                      BottomButton(
                                                        locationController:
                                                            locationController,
                                                        fromSignUp:
                                                            widget.fromSignUp!,
                                                        route:
                                                            widget.route ?? '',
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          if (!ResponsiveHelper.isDesktop(context))
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                              ),
                              child: BottomButton(
                                locationController:
                                    Get.find<LocationController>(),
                                fromSignUp: widget.fromSignUp!,
                                route: widget.route,
                                previousAddress: _addressModel,
                              ),
                            ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String? route;
  final AddressModel? previousAddress;

  const BottomButton({
    super.key,
    required this.locationController,
    required this.fromSignUp,
    required this.route,
    this.previousAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 700,
        child: Column(
          children: [
            CustomButton(
              buttonText: 'use_current_location'.tr,
              fontSize: Dimensions.fontSizeSmall,
              onPressed: () async {
                if (isRedundentClick(DateTime.now())) {
                  return;
                }
                _checkPermission(() async {
                  Get.dialog(const CustomLoader(), barrierDismissible: false);
                  AddressModel address = await locationController
                      .getCurrentLocation(true, deviceCurrentLocation: true);
                  ZoneResponseModel response = await locationController.getZone(
                    address.latitude!,
                    address.longitude!,
                    false,
                  );

                  if (response.isSuccess) {
                    locationController.saveAddressAndNavigate(
                      address,
                      fromSignUp,
                      (route ??
                              RouteHelper.getVehicleSelectViewRoute(
                                serviceId: '',
                                subCategoryId: '',
                                categoryId: '',
                              ))
                          as String?,
                      route != null,
                      true,
                    );
                  } else {
                    Get.back();
                    customSnackBar(response.message);
                  }
                });
              },
              icon: Icons.my_location,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(
                  Dimensions.webMaxWidth,
                  ResponsiveHelper.isDesktop(context) ? 50 : 40,
                ),
                padding: EdgeInsets.zero,
                backgroundColor: Get.isDarkMode
                    ? Colors.grey.withValues(alpha: 0.2)
                    : Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                if (isRedundentClick(DateTime.now())) {
                  return;
                }
                Get.toNamed(
                  RouteHelper.getPickMapRoute(
                    route == null
                        ? fromSignUp
                              ? RouteHelper.signUp
                              : RouteHelper.accessLocation
                        : route!,
                    route != null,
                    'false',
                    null,
                    Get.find<LocationController>().getUserAddress(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: Dimensions.paddingSizeExtraSmall,
                      left: Dimensions.paddingSizeExtraSmall,
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: Get.isDarkMode
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'set_from_map'.tr,
                    textAlign: TextAlign.center,
                    style: robotoMedium.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.deepPurple,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        ),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }
}





// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
//
// class AccessLocationScreen extends StatefulWidget {
//   final bool? fromSignUp;
//   final bool fromHome;
//   final String? route;
//   const AccessLocationScreen({super.key, @required this.fromSignUp, @required this.route, this.fromHome = false});
//
//   @override
//   State<AccessLocationScreen> createState() => _AccessLocationScreenState();
// }
//
// class _AccessLocationScreenState extends State<AccessLocationScreen> {
//   bool isLoggedIn = false;
//   AddressModel? _addressModel;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
//
//     isLoggedIn = Get.find<AuthController>().isLoggedIn();
//     if(isLoggedIn) {
//       Get.find<LocationController>().getAddressList();
//     }
//     _addressModel = Get.find<LocationController>().getUserAddress();
//   }
//
//   final shakeKey = GlobalKey<CustomShakingWidgetState>();
//
//   bool _canExit = GetPlatform.isWeb ? true : false;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPopScopeWidget(
//       onPopInvoked: () {
//         if (_canExit) {
//           if(!GetPlatform.isWeb) {
//             exit(0);
//           }
//         } else {
//           customSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
//           _canExit = true;
//           Timer(const Duration(seconds: 2), () {
//             _canExit = false;
//           });
//         }
//       },
//       child: Scaffold(
//         endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
//         appBar: CustomAppBar(
//           title: 'set_locationnnn'.tr,
//           isBackButtonExist: widget.route != null, // Show back button if coming from another screen
//           shakeKey: shakeKey,
//         ),
//         body: SafeArea(child: Center(
//           child: GetBuilder<LocationController>(builder: (locationController) {
//             return (ResponsiveHelper.isDesktop(context)) &&  !widget.fromHome ? WebLandingPage(fromSignUp: widget.fromSignUp,  route: widget.route, shakeKey: shakeKey,) :
//             Column(
//               children: [
//                 Expanded(
//                   child: FooterBaseView(
//                     isCenter: (! isLoggedIn || locationController.addressList == null || locationController.addressList!.isEmpty),
//                     child: SizedBox(
//                       width:Dimensions.webMaxWidth,
//                       child: WebShadowWrap(
//                         child: isLoggedIn ? Padding(
//                           padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               locationController.addressList != null ? locationController.addressList!.isNotEmpty ?
//                               ListView.builder(
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: locationController.addressList!.length,
//                                 itemBuilder: (context, index) {
//                                   return Center(child: SizedBox(width: 700, child: AddressWidget(
//                                     address: locationController.addressList![index],
//                                     fromAddress: false,
//                                     onTap: () async {
//                                       Get.dialog(const CustomLoader(), barrierDismissible: false);
//                                       AddressModel address = locationController.addressList![index];
//                                       await locationController.setAddressIndex(address,fromAddressScreen: false);
//
//                                       Get.back(); // Close the loader
//
//                                       // Modified: Navigate back to VehicleSelectView after selecting address
//                                       if (widget.route != null && widget.route == 'address') {
//                                         Get.back(); // Go back to VehicleSelectView
//                                       } else {
//                                         locationController.saveAddressAndNavigate(address, widget.fromSignUp!, widget.route, widget.route != null, true);
//                                       }
//                                     },
//                                     selectedUserAddressId: locationController.getUserAddress()?.id,
//                                   )));
//                                 },
//                               ):
//                               NoDataScreen(text: 'no_saved_address_found'.tr,type: NoDataType.address,) :
//                               const Center(child: CircularProgressIndicator()),
//                               const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
//                               if(ResponsiveHelper.isDesktop(context))
//                                 BottomButton(
//                                   locationController: locationController,
//                                   fromSignUp: widget.fromSignUp!,
//                                   route: widget.route,
//                                   returnToPrevious: widget.route == 'address', // Pass flag to indicate return behavior
//                                 ),
//                             ],
//                           ),
//                         ):
//
//                         Center(child: SingleChildScrollView(
//                           physics: const BouncingScrollPhysics(),
//                           child: Center(child: SizedBox(
//                               width: 700,
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(Images.mapLocation, height: 240),
//                                     const SizedBox(height: Dimensions.paddingSizeSmall),
//                                     Text(
//                                       'find_services_near_you'.tr,
//                                       textAlign: TextAlign.center,
//                                       style: robotoMedium.copyWith(
//                                           fontSize: Dimensions.fontSizeExtraLarge,
//                                           color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.primary),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//                                       child: Text(
//                                         'please_select_you_location_to_start_exploring_available_services_near_you'.tr,
//                                         textAlign: TextAlign.center,
//                                         style: robotoRegular.copyWith(
//                                             fontSize: Dimensions.fontSizeSmall,
//                                             color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.primary
//                                         ),),),
//                                     const SizedBox(height: Dimensions.paddingSizeLarge),
//                                     if(ResponsiveHelper.isDesktop(context))
//                                       BottomButton(
//                                         locationController: locationController,
//                                         fromSignUp: widget.fromSignUp!,
//                                         route: widget.route??'',
//                                         returnToPrevious: widget.route == 'address', // Pass flag to indicate return behavior
//                                       ),
//                                   ]))),
//                         )),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if(!ResponsiveHelper.isDesktop(context))
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//                     child: BottomButton(
//                       locationController: Get.find<LocationController>(),
//                       fromSignUp: widget.fromSignUp!,
//                       route: widget.route,
//                       previousAddress: _addressModel,
//                       returnToPrevious: widget.route == 'address', // Pass flag to indicate return behavior
//                     ),
//                   ),
//               ],
//             );
//           }
//           ),
//         ),
//         ),
//       ),
//     );
//   }
// }
//
// class BottomButton extends StatelessWidget {
//   final LocationController locationController;
//   final bool fromSignUp;
//   final String? route;
//   final AddressModel? previousAddress;
//   final bool returnToPrevious;
//
//   const BottomButton({
//     super.key,
//     required this.locationController,
//     required this.fromSignUp,
//     required this.route,
//     this.previousAddress,
//     this.returnToPrevious = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: SizedBox(width: 700, child: Column(children: [
//
//       CustomButton(
//         buttonText: 'use_current_location'.tr,
//         fontSize: Dimensions.fontSizeSmall,
//         onPressed: () async {
//           if(isRedundentClick(DateTime.now())){
//             return;
//           }
//           _checkPermission(() async {
//             Get.dialog(const CustomLoader(), barrierDismissible: false);
//             AddressModel address = await locationController.getCurrentLocation(true,  deviceCurrentLocation: true);
//             ZoneResponseModel response = await locationController.getZone(address.latitude!, address.longitude!, false);
//
//             if(response.isSuccess) {
//               await locationController.setAddressIndex(address, fromAddressScreen: false);
//
//               // Modified: Check if we should return to VehicleSelectView
//               if (returnToPrevious) {
//                 Get.back(); // Close the loader
//                 Get.back(); // Navigate back to VehicleSelectView
//               } else {
//                 locationController.saveAddressAndNavigate(address, fromSignUp, route != null ? route! : '', route != null, true);
//               }
//             }else {
//               Get.back();
//               customSnackBar(response.message);
//             }
//           });
//         },
//         icon: Icons.my_location,
//       ),
//       const SizedBox(height: Dimensions.paddingSizeSmall),
//
//       TextButton(
//         style: TextButton.styleFrom(
//             minimumSize: Size(Dimensions.webMaxWidth,ResponsiveHelper.isDesktop(context)?50 :40),
//             padding: EdgeInsets.zero,
//             backgroundColor: Get.isDarkMode? Colors.grey.withValues(alpha: 0.2):Theme.of(context).primaryColorLight
//         ),
//
//         onPressed: () {
//           if(isRedundentClick(DateTime.now())){
//             return;
//           }
//           Get.toNamed(RouteHelper.getPickMapRoute(
//               route == null ? fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation : route!, route != null, 'false', null, Get.find<LocationController>().getUserAddress()
//           ))?.then((result) {
//             // Modified: Handle return from map selection - navigate back to VehicleSelectView
//             if (returnToPrevious && result != null) {
//               Get.back(); // Navigate back to VehicleSelectView
//             }
//           });
//         },
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Padding(
//             padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall,left: Dimensions.paddingSizeExtraSmall),
//             child: Icon(Icons.location_pin, color: Get.isDarkMode? Colors.white: Theme.of(context).primaryColor),
//           ),
//           Text('set_from_map'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(
//             color:Get.isDarkMode? Colors.white: Colors.deepPurple,
//             fontSize: Dimensions.fontSizeSmall,
//           )),
//         ]),
//       ),
//       const SizedBox(height: Dimensions.paddingSizeSmall),
//     ])));
//   }
//
//   void _checkPermission(Function onTap) async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if(permission == LocationPermission.denied ) {
//       permission = await Geolocator.requestPermission();
//     }
//     if(permission == LocationPermission.denied) {
//       customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
//     }else if(permission == LocationPermission.deniedForever) {
//       Get.dialog(const PermissionDialog());
//     }else {
//       onTap();
//     }
//   }
// }