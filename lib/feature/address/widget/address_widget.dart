/*
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function()? onRemovePressed;
  final Function()? onEditPressed;
  final Function()? onTap;
  final String? selectedUserAddressId;
  final Color? backgroundColor;
  final bool? isShowOnlyEdit;
  const AddressWidget({super.key, required this.address, required this.fromAddress, this.onRemovePressed, this.onEditPressed, this.backgroundColor,
    this.onTap, this.fromCheckout = false, this.selectedUserAddressId , this.isShowOnlyEdit = false});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            top:  Dimensions.paddingSizeDefault,
            bottom:  Dimensions.paddingSizeDefault,
            left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall,
            right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color:  selectedUserAddressId != null && selectedUserAddressId != address.id
                ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5)  : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            border:  selectedUserAddressId != null && selectedUserAddressId == address.id  ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)) : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.center,children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row( children: [
                    selectedUserAddressId != null && selectedUserAddressId == address.id ?
                    Stack(alignment: Alignment.center,children: [
                      Icon(Icons.circle_outlined , color: Theme.of(context).colorScheme.primary,),
                       Icon(Icons.circle, size: 10, color: Theme.of(context).colorScheme.primary,),
                    ]) : Icon(Icons.circle_outlined, color: Theme.of(context).hintColor) ,

                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Text((address.addressLabel != null ? address.addressLabel.toString().toLowerCase() : 'others').tr, style: robotoMedium.copyWith(
                      fontSize: 16, color: selectedUserAddressId != null && selectedUserAddressId != address.id ? Theme.of(context).hintColor: null
                    ),),
                  ]),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                  Text(address.address??"",
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),
            ),
            Row(children: [
              fromAddress ?  selectedUserAddressId != null && selectedUserAddressId == address.id ? const SizedBox() : IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                onPressed: onEditPressed,
              )
                  : isShowOnlyEdit == false ?  const SizedBox() : IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                onPressed: onEditPressed,
              ),

              if(address.id != null)
                fromAddress ? selectedUserAddressId != null && selectedUserAddressId == address.id ? const SizedBox() :
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size:  25),
                    onPressed: onRemovePressed) : const SizedBox(),
            ],)
          ]),
        ),
      ),
    );
  }
}*/
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function()? onRemovePressed;
  final Function()? onEditPressed;
  final Function()? onTap;
  final String? selectedUserAddressId;
  final Color? backgroundColor;
  final bool? isShowOnlyEdit;

  const AddressWidget({
    super.key,
    required this.address,
    required this.fromAddress,
    this.onRemovePressed,
    this.onEditPressed,
    this.backgroundColor,
    this.onTap,
    this.fromCheckout = false,
    this.selectedUserAddressId,
    this.isShowOnlyEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedUserAddressId == address.id.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            top: Dimensions.paddingSizeDefault,
            bottom: Dimensions.paddingSizeDefault,
            left: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeDefault
                : Dimensions.paddingSizeSmall,
            right: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeDefault
                : Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            border: isSelected
                ? Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.5))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Left side content (radio + label + address)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Label with "radio button" style icon
                      Row(
                        children: [
                          isSelected
                              ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary),
                              Icon(Icons.circle,
                                  size: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary),
                            ],
                          )
                              : Icon(Icons.circle_outlined,
                              color: Theme.of(context).hintColor),
                          const SizedBox(
                              width: Dimensions.paddingSizeSmall),
                          Text(
                            (address.addressLabel ?? 'others').tr,
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: isSelected
                                  ? Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  : Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      /// Actual address text
                      Text(
                        address.address ?? "",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              /// Right side action buttons
              Row(
                children: [
                  if (fromAddress || isShowOnlyEdit == true)
                    (!isSelected || !fromAddress)
                        ? IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.blue, size: 25),
                      onPressed: onEditPressed,
                    )
                        : const SizedBox(),

                  if (fromAddress && address.id != null && !isSelected)
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red, size: 25),
                      onPressed: onRemovePressed,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}