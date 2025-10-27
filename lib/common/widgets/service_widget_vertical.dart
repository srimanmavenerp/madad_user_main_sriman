// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
//
// class ServiceWidgetVertical extends StatelessWidget {
//   final Service service;
//   final String fromType;
//   final String fromPage;
//   final ProviderData? providerData;
//   final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
//
//   const ServiceWidgetVertical({
//     super.key, required this.service, required this.fromType,
//     this.fromPage ="", this.providerData, this.signInShakeKey}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     num lowestPrice = 0.0;
//
//     if(fromType == 'fromCampaign'){
//       if(service.variations != null){
//         lowestPrice = service.variations![0].price!;
//         for (var i = 0; i < service.variations!.length; i++) {
//           if (service.variations![i].price! < lowestPrice) {
//             lowestPrice = service.variations![i].price!;
//           }
//         }
//       }
//     }else{
//       if(service.variationsAppFormat != null){
//         if(service.variationsAppFormat!.zoneWiseVariations != null){
//           lowestPrice = service.variationsAppFormat!.zoneWiseVariations![0].price!;
//           for (var i = 0; i < service.variationsAppFormat!.zoneWiseVariations!.length; i++) {
//             if (service.variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
//               lowestPrice = service.variationsAppFormat!.zoneWiseVariations![i].price!;
//             }
//           }
//         }
//       }
//     }
//
//
//     Discount discountModel =  PriceConverter.discountCalculation(service);
//     return OnHover(
//       isItem: true,
//       child: GetBuilder<ServiceController>(builder: (serviceController){
//         return Stack(alignment: Alignment.bottomRight, children: [
//           Stack(children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                 boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
//               ),
//
//               child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
//                   Expanded(
//                     flex: ResponsiveHelper.isDesktop(context) && !Get.find<LocalizationController>().isLtr ? 5 : 8,
//                     child: Stack(children: [
//
//                       ClipRRect(
//                         borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
//                         child: CustomImage(
//                           image: '${service.thumbnailFullPath}',
//                           fit: BoxFit.cover,width: double.maxFinite,
//                           height: double.infinity,
//                         ),
//                       ),
//
//                       discountModel.discountAmount! > 0 ? Align(alignment: Alignment.topLeft,
//                         child: DiscountTagWidget(
//                           discountAmount: discountModel.discountAmount,
//                           discountAmountType: discountModel.discountAmountType,
//                         ),
//                       ) : const SizedBox(),
//
//                     ],),
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight -2 ),
//                     child: Text(
//                       service.name ?? "",
//                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
//                       maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
//                     ),
//                   ),
//
//
//
//
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'starts_from'.tr,
//                             style: robotoRegular.copyWith(
//                                 fontSize: Dimensions.fontSizeSmall,
//                                 color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .5)),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if(discountModel.discountAmount! > 0)
//                                 Directionality(
//                                   textDirection: TextDirection.ltr,
//                                   child: Text(
//                                     PriceConverter.convertPrice(lowestPrice.toDouble()),
//                                     maxLines: 2,
//                                     style: robotoRegular.copyWith(
//                                         fontSize: Dimensions.fontSizeSmall,
//                                         decoration: TextDecoration.lineThrough,
//                                         color: Theme.of(context).colorScheme.error),),
//                                 ),
//                               discountModel.discountAmount! > 0?
//                               Directionality(
//                                 textDirection: TextDirection.ltr,
//                                 child: Text(
//                                   PriceConverter.convertPrice(
//                                       lowestPrice.toDouble(),
//                                       discount: discountModel.discountAmount!.toDouble(),
//                                       discountType: discountModel.discountAmountType),
//                                   style: robotoMedium.copyWith(
//                                       fontSize: Dimensions.fontSizeDefault,
//                                       color:  Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
//                                 ),
//                               ):
//                               Directionality(
//                                 textDirection: TextDirection.ltr,
//                                 child: Text(
//                                   PriceConverter.convertPrice((lowestPrice.toDouble() ?? '') as double?),
//                                   style: robotoMedium.copyWith(
//                                       fontSize:Dimensions.fontSizeDefault ,
//                                       color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ]),
//                   ),
//                 ],),
//               ),
//             ),
//             Positioned.fill(child: RippleButton(onTap: () {
//
//               if(fromPage=="search_page"){
//                 Get.toNamed(RouteHelper.getServiceRoute(service.id!,fromPage:"search_page"),);
//               }else{
//                 Get.toNamed(RouteHelper.getServiceRoute(service.id!),);
//               }
//             }))
//           ],),
//
//           if(fromType != 'fromCampaign')
//             Align(
//               alignment:Get.find<LocalizationController>().isLtr ? Alignment.bottomRight : Alignment.bottomLeft,
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                     child: Icon(Icons.add,
//                       color: Get.isDarkMode? Theme.of(context).primaryColorLight : Colors.deepPurple,
//                       size: Dimensions.paddingSizeExtraLarge,
//                     ),
//                   ),
//                   Positioned.fill(child: RippleButton(onTap: () {
//                     showModalBottomSheet(
//                         useRootNavigator: true,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         context: context, builder: (context) => ServiceCenterDialog(service: service, providerData: providerData,));
//                   }))
//                 ],
//               ),
//             ),
//
//           Align(
//             alignment: Alignment.topRight,
//             child: FavoriteIconWidget(
//               value: service.isFavorite,
//               serviceId:  service.id!,
//               signInShakeKey: signInShakeKey,
//             ),
//           )
//
//         ],);
//       }),
//     );
//   }
// }




import 'package:get/get.dart';
import 'package:get/get.dart';
 import 'package:madaduser/utils/core_export.dart';



class ServiceWidgetVertical extends StatelessWidget {
  final Service service;
  final String fromType;
  final String fromPage;
  final ProviderData? providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;

  const ServiceWidgetVertical({
    super.key, required this.service, required this.fromType,
    this.fromPage ="", this.providerData, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    num lowestPrice = 0.0;

    if(fromType == 'fromCampaign'){
      if(service.variations != null){
        lowestPrice = service.variations![0].price!;
        for (var i = 0; i < service.variations!.length; i++) {
          if (service.variations![i].price! < lowestPrice) {
            lowestPrice = service.variations![i].price!;
          }
        }
      }
    }else{
      if(service.variationsAppFormat != null){
        if(service.variationsAppFormat!.zoneWiseVariations != null){
          lowestPrice = service.variationsAppFormat!.zoneWiseVariations![0].price!;
          for (var i = 0; i < service.variationsAppFormat!.zoneWiseVariations!.length; i++) {
            if (service.variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
              lowestPrice = service.variationsAppFormat!.zoneWiseVariations![i].price!;
            }
          }
        }
      }
    }

    Discount discountModel =  PriceConverter.discountCalculation(service);
    return OnHover(
      isItem: true,
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return Stack(alignment: Alignment.bottomRight, children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: ResponsiveHelper.isDesktop(context) && !Get.find<LocalizationController>().isLtr ? 5 : 8,
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                          child: CustomImage(
                            image: '${service.thumbnailFullPath}',
                            fit: BoxFit.cover, width: double.maxFinite,
                            height: double.infinity,
                          ),
                        ),
                        const SizedBox(),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight - 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name ?? "",
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 8),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned.fill(child: RippleButton(onTap: () {
            //   if(fromPage=="search_page"){
            //     Get.toNamed(RouteHelper.getServiceRoute(service.id!,fromPage:"search_page"),);
            //   }else{
            //     Get.toNamed(RouteHelper.getServiceRoute(service.id!),);
            //   }
            // }))    //// Balu
          ]),


        ]);
      }),
    );
  }
}