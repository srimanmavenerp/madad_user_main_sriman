import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class AcceptProviderRequestView extends StatelessWidget {
 final ProviderOfferData providerOfferData;
 final String postId;
 final int length;
  const AcceptProviderRequestView({super.key, required this.providerOfferData, required this.postId, required this.length}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController){
      return GestureDetector(
        onTap: (){
          Get.toNamed(RouteHelper.getProviderOfferDetailsScreen(
              postId,providerOfferData
          ));
        },
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
            ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                image: providerOfferData.provider?.logoFullPath??"",
              ),
            ),

            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Expanded(
              child: Stack(
                alignment:Get.find<LocalizationController>().isLtr? Alignment.topRight: Alignment.topLeft,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text(providerOfferData.provider?.companyName??"", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      children: [
                        Icon(Icons.star,color: Theme.of(context).colorScheme.primary,size: 10,),
                        Directionality(textDirection: TextDirection.ltr,
                          child: Text(" ${providerOfferData.provider?.avgRating.toString()??"" }",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)),),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        InkWell(
                          child: Text('${providerOfferData.provider?.ratingCount??"0"} ${'reviews'.tr}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                        ),

                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("price_offered".tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).colorScheme.error),),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text(PriceConverter.convertPrice(double.tryParse(providerOfferData.offeredPrice.toString())),style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).colorScheme.primary)),

                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(mainAxisAlignment: MainAxisAlignment.end,children: [

                      GestureDetector(
                        onTap:() async {
                          Get.dialog( ConfirmationDialog(
                              icon: Images.ignore,
                              title: 'decline'.tr,
                              description: 'do_you_want_to_decline_this_request'.tr,
                              yesButtonText: 'decline',
                              onYesPressed: () async {

                                Get.back();
                                Get.dialog(const CustomLoader(), barrierDismissible: false,);
                                await createPostController.updatePostStatus(postId, providerOfferData.provider!.id!, 'deny');

                                if(length>1){
                                  await createPostController.getProvidersOfferList(1, postId, reload: false);
                                  Get.back();
                                }else{
                                  Get.back();
                                  Get.offNamed(RouteHelper.getMyPostScreen());
                                }
                              },
                          ),useSafeArea: true);
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
                          child: Center(child: Text('decline'.tr,style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),)),
                        ),
                      ),

                      const SizedBox(width: Dimensions.paddingSizeSmall,),

                      GestureDetector(
                        onTap:() async {

                          if(createPostController.checkProviderAvailability(providerData: providerOfferData.provider ?? ProviderData())){
                            Get.toNamed(RouteHelper.getCustomPostCheckoutRoute(
                                postId,providerOfferData.provider!.id!,providerOfferData.offeredPrice!, providerOfferData.id!
                            ));
                          }else{
                            customSnackBar("your_selected_provider_is_unavailable_right_now".tr);
                          }

                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
                          child: Center(child: Text('accept'.tr,style: robotoRegular.copyWith(color: Colors.white),)),
                        ),
                      ),
                    ],)

                  ],),
                  Image.asset(Images.messageIcon,height: 22,width: 22,),
                ],
              ),
            )
          ],),
        ),
      );
    });
  }
}
