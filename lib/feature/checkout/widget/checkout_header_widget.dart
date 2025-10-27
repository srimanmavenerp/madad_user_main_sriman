import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class CheckoutHeaderWidget extends StatelessWidget {
  final String pageState;
  const CheckoutHeaderWidget({super.key, required this.pageState}) ;

  @override
  Widget build(BuildContext context) {
    return SizedBox( width: 426, child: GetBuilder<CheckOutController>(builder: (controller){
      return Column( children: [
        Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
          child:  Stack( children: [

            SizedBox( height: 55, child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              CustomHeaderIcon( assetIconSelected: Images.orderDetailsSelected, assetIconUnSelected: Images.orderDetailsUnselected,
                isActiveColor: controller.currentPageState == PageState.orderDetails ? true : false,
              ),

              controller.currentPageState == PageState.orderDetails ?
              const CustomHeaderLine(color: Color(0xffFF833D), gradientColor1: Color(0xffFDA21A), gradientColor2: Colors.orangeAccent,) :
              const CustomHeaderLine(gradientColor1: Colors.deepOrange, gradientColor2: Colors.orangeAccent),

              CustomHeaderIcon(assetIconSelected: Images.paymentSelected, assetIconUnSelected: Images.paymentUnSelected,
                isActiveColor: controller.currentPageState == PageState.payment ? true : false,
              ),

              controller.cancelPayment ?
              const CustomHeaderLine(cancelOrder: true, gradientColor1: Colors.grey, gradientColor2: Colors.grey,) : controller.currentPageState == PageState.payment ?
              const CustomHeaderLine(color: Colors.green, gradientColor1: Colors.orangeAccent, gradientColor2: Colors.green,) :
              const CustomHeaderLine(gradientColor1: Colors.orangeAccent, gradientColor2: Colors.greenAccent,),

              CustomHeaderIcon(assetIconSelected: controller.cancelPayment? Images.completeSelected : Images.completeSelected,
                assetIconUnSelected: Images.completeUnSelected,
                isActiveColor: controller.currentPageState == PageState.complete ? true : false
              ),

            ],),),


            controller.currentPageState == PageState.orderDetails  && PageState.orderDetails.name == pageState ?
            Positioned( top: 0, bottom: 0,
              left: Get.find<LocalizationController>().isLtr ? 0: null,
              right:Get.find<LocalizationController>().isLtr ? null: 0,
              child: Container( height: 55, width: 55,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(fit: BoxFit.fill, image: AssetImage( Images.orderDetailsSelected,),),
                ),
              ),) : const SizedBox(),


            controller.currentPageState == PageState.payment  || PageState.payment.name == pageState ?
            Positioned( child: Align( alignment: Alignment.center,
              child: Container( height: 55, width: 55,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  image: DecorationImage( fit: BoxFit.fill, image: AssetImage( Images.paymentSelected)),
                ),
              ),
            )) :  const SizedBox(),


            controller.currentPageState == PageState.complete || pageState == 'complete' ?
            Positioned( top: 0, bottom: 0,
              right: Get.find<LocalizationController>().isLtr ? 0:null,
              left: Get.find<LocalizationController>().isLtr ? null: 0,
              child: Container( height: 55, width: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(fit: BoxFit.fill, image: AssetImage( Images.completeSelected,),),
                ),
              ),
            ) : const SizedBox(),


          ]),
        ),

        Padding( padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault),
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,  crossAxisAlignment: CrossAxisAlignment.center, children:  [
            CustomText( text: "booking_details".tr, isActive :controller.currentPageState == PageState.orderDetails && PageState.orderDetails.name == pageState),
            Padding(padding: const EdgeInsets.only(right: 25.0),
              child: CustomText(text: "payment".tr,isActive :controller.currentPageState == PageState.payment || PageState.payment.name == pageState),
            ),
            CustomText(text: "complete".tr,isActive : controller.currentPageState == PageState.complete  || pageState == 'complete'),
          ]),
        ),

      ]);},
    ));
  }
}
