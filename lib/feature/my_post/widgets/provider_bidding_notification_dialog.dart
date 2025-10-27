import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderBiddingNotificationDialog extends StatelessWidget {
  final ProviderOfferData providerOfferData;
  final String postId;
  const ProviderBiddingNotificationDialog({super.key, required this.providerOfferData, required this.postId}) ;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: 40),
      child: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: (){
              Get.back();
              Get.toNamed(RouteHelper.getProviderOfferDetailsScreen(
                  postId, providerOfferData
              ));
            },
            child: Column(mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                   color: Theme.of(context).cardColor,
                 ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(child: const Row(mainAxisAlignment: MainAxisAlignment.end,children: [Icon(Icons.highlight_remove,size: 20,)]),
                            onTap: ()=>Get.back(),
                          ),
                          Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                                image: providerOfferData.provider?.logoFullPath??"",
                              ),
                            ),

                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
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
                                    Text(PriceConverter.convertPrice(double.tryParse(providerOfferData.offeredPrice??"0")??0),style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).colorScheme.primary)),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Row(mainAxisAlignment: MainAxisAlignment.end,children: [

                                  GestureDetector(
                                    onTap:() {
                                      Get.back();
                                      Get.find<CreatePostController>().updatePostStatus(postId, providerOfferData.provider!.id!, 'deny');
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
                                      child: Center(child: Text('decline'.tr,style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),)),
                                    ),
                                  ),

                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  CustomButton(
                                    buttonText: 'accept'.tr,
                                    width:  80,
                                    height: 30,
                                    radius: Dimensions.radiusSmall,
                                    onPressed: () {
                                      Get.back();
                                      Get.toNamed(RouteHelper.getCustomPostCheckoutRoute(
                                          postId,providerOfferData.provider!.id!,providerOfferData.offeredPrice!, providerOfferData.id!
                                      ));
                                    },
                                  )
                                ],)

                              ],),
                            )
                          ],)
                        ],),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


