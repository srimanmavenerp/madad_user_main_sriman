import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class ReviewRecommendationDialog extends StatefulWidget {

  final String id;

  const ReviewRecommendationDialog({
    super.key,
    required this.id,
  }) ;

  @override
  State<ReviewRecommendationDialog> createState() => _ReviewRecommendationDialogState();
}

class _ReviewRecommendationDialogState extends State<ReviewRecommendationDialog> {
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
            width:ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth/1.5:Dimensions.webMaxWidth,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeDefault),
                            child: Icon(Icons.close,color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6),),
                          )),
                    ),
                    Text(
                      'how_was_your_last_service'.tr,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).colorScheme.primary),),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text(
                      'leave_a_review'.tr,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge,),
                    Image.asset(
                      Images.emptyReview,
                      scale:Dimensions.paddingSizeSmall,
                      color:Get.isDarkMode ?  Theme.of(context).primaryColorLight: Colors.deepPurple,),
                    const SizedBox(height: 30.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: 40,
                            width: ResponsiveHelper.isDesktop(context)? 200: 150,
                            child: TextButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).hoverColor)),
                                onPressed: () => Get.back(),
                                child: Center(
                                  child: Text(
                                    'skip'.tr,
                                    style: robotoMedium.copyWith(color:Get.isDarkMode ?  Colors.white:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6),
                                        fontSize: Dimensions.fontSizeSmall),),
                                )
                            )
                        ),

                        CustomButton(
                          height: 40,
                          width: ResponsiveHelper.isDesktop(context)? 200: 150,
                          fontSize: Dimensions.fontSizeSmall,
                          buttonText: 'give_review'.tr,
                          onPressed: () {
                            Get.back();
                            Get.toNamed(RouteHelper.getRateReviewScreen(
                                widget.id
                            ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge,)
                  ]),
            )),
      ),
    );
  }
}
