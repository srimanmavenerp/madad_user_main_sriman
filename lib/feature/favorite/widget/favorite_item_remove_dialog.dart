import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class FavoriteItemRemoveDialog extends StatefulWidget {
  final String? serviceId;
  final String? providerId;

  const FavoriteItemRemoveDialog({super.key, this.serviceId, this.providerId});

  @override
  State<FavoriteItemRemoveDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<FavoriteItemRemoveDialog> {

  @override
  Widget build(BuildContext context) {
    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor(){
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.isWeb()? 0 :Dimensions.cartDialogPadding),
      child: PointerInterceptor(
        child: Container(
          width:ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(height: 5, width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(Get.context!).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
              ),
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault * 1.5),
            ),

            Image.asset(widget.providerId !=null ? Images.favoriteProvider : Images.favoriteService, height: 70, fit: BoxFit.fitHeight,),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault * 2,),
              child: Text( widget.providerId != null ? "want_to_remove_provider".tr : widget.serviceId !=null ? "want_to_remove_service".tr:"",
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault * 2,),
              child: Text( widget.providerId != null ? "provider_remove_message".tr : widget.serviceId !=null ? "service_remove_message".tr :"",
                maxLines: 3,
                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge * 1.3),

            Padding(
              padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeExtraLarge,
                  right: Dimensions.paddingSizeExtraLarge
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Expanded(child: CustomButton(
                      buttonText: 'cancel'.tr,
                      backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                      onPressed: () => Get.back(),
                      textColor: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8)
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),


                  Expanded(child: CustomButton(
                    buttonText : 'remove'.tr,
                    onPressed: () async {
                      Get.back();
                      Get.dialog(const CustomLoader(), barrierDismissible: false);

                     if( widget.serviceId !=null){
                       await Get.find<MyFavoriteController>().removeFavoriteService(widget.serviceId!);
                     } else if(widget.providerId != null){
                       await Get.find<MyFavoriteController>().removeFavoriteProvider(widget.providerId!);
                     } else{
                       Get.back();
                     }
                      Get.back();
                    },
                    backgroundColor: Theme.of(context).colorScheme.error,

                  )),


                ],),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge * 2),

          ])
        ),
      ),
    );
  }
}