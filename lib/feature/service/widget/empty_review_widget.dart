import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class EmptyReviewWidget extends StatelessWidget {
  const EmptyReviewWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebShadowWrap(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.emptyReview,scale:Dimensions.paddingSizeSmall,color: Get.isDarkMode ?  Theme.of(context).primaryColorLight: Colors.deepPurple,),
                const SizedBox(height: 20.0,),
                Text("no_review_yet".tr,style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)),),
                const SizedBox(height: 50.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
