import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class BackToHomeButtonWidget extends StatelessWidget {
  const BackToHomeButtonWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.find<CheckOutController>().updateState(PageState.orderDetails);
        Get.offAllNamed(RouteHelper.getMainRoute('home'));
      },
      child: Column(children: [
          const Expanded(child: SizedBox()),

          Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            margin: const EdgeInsets.all( Dimensions.paddingSizeSmall),
            child: Center(
              child: Text(
                'back_to_homepage'.tr,
                style:
                robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeDefault
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
