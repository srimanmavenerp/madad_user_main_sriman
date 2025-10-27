


import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final AddressModel? address;
  const AddAddressScreen({super.key, required this.fromCheckout, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _serviceAddressController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _parkingDetailsController = TextEditingController();


  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _serviceAddressNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _countryNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();


  LatLng? _initialPosition;
  LatLng? _lastPosition;
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition? _cameraPosition;



  @override
  void initState() {
    super.initState();
    Get.find<LocationController>().resetAddress();
    if(widget.address != null) {
      setControllerData();
    }else{
      Get.find<LocationController>().updateAddressLabel(addressLabelString: 'home'.tr);
      Get.find<LocationController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode!;
      _countryController.text = '';
      _initialPosition = LatLng(
        Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.0000,
        Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.0000,
      );
    }
    _lastPosition = _initialPosition;
  }

  setControllerData() async {


    _serviceAddressController.text = widget.address?.address??"";
    _contactPersonNameController.text = widget.address?.contactPersonName??'';

    String numberAfterValidation = PhoneVerificationHelper.isPhoneValid(
        widget.address?.contactPersonNumber ?? Get.find<UserController>().userInfoModel?.phone ?? "", fromAuthPage: false);
    if(numberAfterValidation == ""){
      _contactPersonNumberController.text = widget.address?.contactPersonNumber?.replaceAll("null", "") ?? "";
    }else{
      _contactPersonNumberController.text = numberAfterValidation;
    }
    _cityController.text = widget.address?.city ?? '';
    _countryController.text = widget.address?.country ?? '';
    _streetController.text = widget.address?.street ?? "";
    _zipController.text = widget.address?.zipCode ?? '';
    _houseController.text = widget.address?.house ?? '';
    _floorController.text = widget.address?.floor ?? '';

    Get.find<LocationController>().updateAddressLabel(addressLabelString: widget.address?.addressLabel??"");
    Get.find<LocationController>().setPlaceMark(addressModel : widget.address, parkingDetails: '${widget.address?.parkingDetails}');
    Get.find<LocationController>().buttonDisabledOption = false;

    Get.find<LocationController>().setUpdateAddress(widget.address!);
    _initialPosition = LatLng(
      double.parse(widget.address?.latitude ?? '0'),
      double.parse(widget.address?.longitude ?? '0'),
    );
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: widget.address == null ? 'add_new_address'.tr : 'update_address'.tr),
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      body: FooterBaseView( child: Center( child: WebShadowWrap(child: SizedBox(width: Dimensions.webMaxWidth,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
          child: GetBuilder<LocationController>(builder: (locationController) {
            return Form(key: addressFormKey, child: Column(children: [

              if(!ResponsiveHelper.isDesktop(context))
                Column(children: [
                  _firstList(locationController),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),
                  _secondList(locationController),
                ],),

              if(ResponsiveHelper.isDesktop(context))
                Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child: _firstList(locationController),),
                  const SizedBox(width: Dimensions.paddingSizeLarge * 2,),
                  Expanded(
                    child: _secondList(locationController),
                  ),
                ]),
              SizedBox(height: ResponsiveHelper.isDesktop(context) ? 50 : 100 + bottomPadding,),

              ResponsiveHelper.isDesktop(context) ?
              CustomButton(
                radius: Dimensions.radiusDefault, fontSize: Dimensions.fontSizeLarge,
                buttonText: widget.address == null ? 'save_location'.tr : 'update_address'.tr,
                isLoading: locationController.isLoading,
                onPressed : (locationController.buttonDisabled || locationController.loading) ? null : () => _saveAddress(locationController),
              ) : const SizedBox(),

            ]));
          }),
        ),
      )))),

      bottomSheet: !ResponsiveHelper.isDesktop(context) ? GetBuilder<LocationController>(builder: (locationController){
        return SizedBox( height: 70 + bottomPadding,
          child: CustomButton(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            radius: Dimensions.radiusDefault, fontSize: Dimensions.fontSizeLarge,
            isLoading: locationController.isLoading,
            buttonText: widget.address == null ? 'save_location'.tr : 'update_address'.tr,
            onPressed : (locationController.buttonDisabled  || locationController.loading) ? null : () => _saveAddress(locationController),
          ),
        );
      }): const SizedBox(),
    );
  }

  void _saveAddress (LocationController locationController ){
    final isValid = addressFormKey.currentState!.validate();

    if(isValid ){
      addressFormKey.currentState!.save();

      AddressModel addressModel = AddressModel(
        id: widget.address?.id ,
        addressType: locationController.selectedAddressType.name,
        addressLabel:locationController.selectedAddressLabel.name.toLowerCase(),
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: Get.find<LocationController>().countryDialCode + PhoneVerificationHelper.isPhoneValid(Get.find<LocationController>().countryDialCode + _contactPersonNumberController.text, fromAuthPage: false),
        address: _serviceAddressController.text,
        city: _cityController.text,
        zipCode: _zipController.value.text,
        country: _countryController.text,
        house: _houseController.text,
        floor: _floorController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        street: _streetController.text,

        parkingDetails: _parkingDetailsController.text,

      );
      if (kDebugMode) {
        print("After Address Model and Save Button , Country Code is ${addressModel.contactPersonNumber}");
      }
      if(widget.address == null) {
        locationController.addAddress(addressModel, true);
      }else {
        if(widget.address!.id!=null && widget.address!.id!="null"){
          locationController.updateAddress(addressModel, widget.address!.id!).then((response) {
            if(response.isSuccess!) {
              if(widget.fromCheckout){
                locationController.updateSelectedAddress(addressModel);
              }
              Get.back();
              customSnackBar(response.message!.tr,type : ToasterMessageType.success);
            }else {
              customSnackBar(response.message!.tr);
            }
          });
        }else{
          locationController.updateSelectedAddress(addressModel);
          Get.back();
        }
      }
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }

  Widget _firstList(LocationController locationController) {
    return Column(children: [
      const SizedBox(height: Dimensions.paddingSizeDefault),
      CustomTextField(
        title: 'name'.tr,
        hintText: 'contact_person_name_hint'.tr,
        inputType: TextInputType.name,
        controller: _contactPersonNameController,
        focusNode: _nameNode,
        nextFocus: _numberNode,
        capitalization: TextCapitalization.words,
        onValidate: (String? value){
          return FormValidation().isValidLength(value!);
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      CustomTextField(
        onCountryChanged: (CountryCode countryCode) {
          locationController.countryDialCode = countryCode.dialCode!;
        },
        countryDialCode: locationController.countryDialCode,
        title: 'phone_number'.tr,
        hintText: 'contact_person_number_hint'.tr,
        inputType: TextInputType.phone,
        inputAction: TextInputAction.done,
        focusNode: _numberNode,
        nextFocus: _serviceAddressNode,
        controller: _contactPersonNumberController,
        onValidate: (String? value){
          if(value == null || value.isEmpty){
            return 'please_enter_phone_number'.tr;
          }
          return FormValidation().isValidPhone(
              locationController.countryDialCode+(value),
              fromAuthPage: false
          );
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge * 1.2),

      Container(
        height: ResponsiveHelper.isDesktop(context) ? 250 : 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
        ),
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Stack(clipBehavior: Clip.none, children: [
            if(_initialPosition != null)
              GoogleMap(
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),

                initialCameraPosition: CameraPosition(
                  target: _initialPosition!,
                  zoom: 14.4746,
                ),
                zoomControlsEnabled: false,
                onCameraIdle: () {
                  if (_cameraPosition != null && _lastPosition != null) {
                    final target = _cameraPosition!.target;
                    if ((target.latitude - _lastPosition!.latitude).abs() > 1e-6 ||
                        (target.longitude - _lastPosition!.longitude).abs() > 1e-6) {
                      try {
                        locationController.updatePosition(_cameraPosition!, true, formCheckout: widget.fromCheckout);
                      } catch (error) {
                        if (kDebugMode) {
                          print('error : $error');
                        }
                      }
                      _lastPosition = LatLng(target.latitude, target.longitude);
                    }
                  }
                },
                onCameraMove: ((position) => _cameraPosition = position),
                onMapCreated: (GoogleMapController controller) {
                  locationController.setMapController(controller);
                  _controller.complete(controller);

                  if(widget.address == null) {
                    locationController.getCurrentLocation(true, mapController: controller);
                  }
                },
                style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                myLocationButtonEnabled: false,

              ),
            locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
            Center(child: !locationController.loading ? Image.asset(Images.marker, height: 40, width: 40,)
                : const CircularProgressIndicator()),
            Positioned(
              bottom: 10,
              left:Get.find<LocalizationController>().isLtr ? null: Dimensions.paddingSizeSmall,
              right:Get.find<LocalizationController>().isLtr ?  0:null,
              child: InkWell(
                onTap: () => _checkPermission(() {
                  locationController.getCurrentLocation(true, mapController: locationController.mapController);
                }),
                child: Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color:Theme.of(context).primaryColorLight.withValues(alpha: .5)),
                  child: Icon(Icons.my_location, color: Colors.deepPurple, size: 20),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left:Get.find<LocalizationController>().isLtr ? null: Dimensions.paddingSizeSmall,
              right:Get.find<LocalizationController>().isLtr ?  0:null,
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.getPickMapRoute('add-addres', false, '${widget.fromCheckout}', null, null),
                    arguments: PickMapScreen(
                      fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                      route: null, canRoute: false, formCheckout: widget.fromCheckout, zone: null,
                    ),
                  );
                },
                child: Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).primaryColorLight.withValues(alpha: .5)),
                  child: Icon(Icons.fullscreen, color: Colors.deepPurple, size: 20),
                ),
              ),
            ),
          ]),
        ),
      ),

    ],);
  }

  Widget _secondList(LocationController locationController) {
    return Column(children: [
      const AddressLabelWidget(),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
      CustomTextField(
          title: 'service_address'.tr,
          hintText: 'service_address_hint'.tr,
          inputType: TextInputType.streetAddress,
          focusNode: _serviceAddressNode,
          nextFocus: _houseNode,
          controller: _serviceAddressController..text = locationController.address.address ?? "",
          onChanged: (text) => locationController.setPlaceMark(address: text, parkingDetails: '${_parkingDetailsController.text}'),
          onValidate: (String? value){
            if(value == null || value.isEmpty){
              return 'enter_your_address'.tr;
            }
            return null;
          }
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      Row(
        children: [
          Expanded(
            child: CustomTextField(
              title: 'Building No'.tr,
              hintText: 'enter_house_no'.tr,
              inputType: TextInputType.streetAddress,
              focusNode: _houseNode,
              nextFocus: _floorNode,
              controller: _houseController..text = locationController.address.house ?? "",
              onChanged: (text) => locationController.setPlaceMark(house: text, parkingDetails: '${_parkingDetailsController.text}'),
              isRequired: false,
            ),
          ),

          const SizedBox(width: Dimensions.paddingSizeTextFieldGap),

          Expanded(
            child: CustomTextField(
              title: 'Flat no'.tr,
              hintText: 'enter_flat_no'.tr,
              inputType: TextInputType.streetAddress,
              focusNode: _floorNode,
              nextFocus: _cityNode,
              controller: _floorController..text = locationController.address.floor ?? "",
              onChanged: (text) => locationController.setPlaceMark(floor: text, parkingDetails: '${_parkingDetailsController.text}'),
              isRequired: false,
            ),
          ),
        ],
      ),

      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      Row(
        children: [
          Expanded(
            child: CustomTextField(
              title: 'Landkmark'.tr,
              hintText: 'enter_landmark'.tr,
              inputType: TextInputType.streetAddress,
              focusNode: _cityNode,
              nextFocus: _countryNode,
              controller: _cityController..text = locationController.address.city ?? "",
              onChanged: (text) => locationController.setPlaceMark(city: text, parkingDetails: '${_parkingDetailsController.text}'),
              isRequired: false,
            ),
          ),

          const SizedBox(width: Dimensions.paddingSizeTextFieldGap),

          Expanded(
            child: CustomTextField(
              title: 'country'.tr,
              hintText: 'enter_country'.tr,
              inputType: TextInputType.text,
              focusNode: _countryNode,
              inputAction: TextInputAction.next,
              nextFocus: _zipNode,
              controller: _countryController..text = locationController.address.country ?? "",
              onChanged: (text) => locationController.setPlaceMark(country: text, parkingDetails: '${_parkingDetailsController.text}'),
              isRequired: false,
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      CustomTextField(
        title: 'Parking Details',
        hintText: 'Enter parking details',
        inputType: TextInputType.text,
        focusNode: _zipNode,
        inputAction: TextInputAction.done,
        controller: _parkingDetailsController, // <-- Remove ..text assignment here
        onChanged: (text) => locationController.setPlaceMark(parkingDetails: text),
        onEditingComplete: () {
          locationController.setPlaceMark(parkingDetails: _parkingDetailsController.text);
          FocusScope.of(context).unfocus();
        },
        isRequired: false,
      )


    ]);
  }
}