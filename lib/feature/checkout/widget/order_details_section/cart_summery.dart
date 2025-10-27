// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
//
//
// class CartSummery extends StatelessWidget {
//   const CartSummery({super.key}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CheckOutController>(builder: (checkoutController){
//       return GetBuilder<ScheduleController>(builder: (scheduleController){
//         return GetBuilder<CartController>(
//             builder: (cartController){
//
//               int scheduleDaysCount = scheduleController.scheduleDaysCount > 0 ? scheduleController.scheduleDaysCount : 1;
//
//               ConfigModel configModel = Get.find<SplashController>().configModel;
//               List<CartModel> cartList = cartController.cartList;
//               bool walletPaymentStatus = cartController.walletPaymentStatus;
//               int applicableCouponCount = CheckoutHelper.getNumberOfDaysForApplicableCoupon(pickedScheduleDays:scheduleDaysCount) ?? 1;
//               double additionalCharge = CheckoutHelper.getAdditionalCharge();
//               bool isPartialPayment = CheckoutHelper.checkPartialPayment(walletBalance: cartController.walletBalance, bookingAmount: cartController.totalPrice);
//               double paidAmount = CheckoutHelper.calculatePaidAmount(walletBalance: cartController.walletBalance, bookingAmount: cartController.totalPrice);
//               double subTotalPrice =  CheckoutHelper.calculateSubTotal(cartList: cartList, daysCount: scheduleDaysCount);
//               double disCount = CheckoutHelper.calculateDiscount(cartList: cartList, discountType: DiscountType.general, daysCount: scheduleDaysCount);
//               double campaignDisCount = CheckoutHelper.calculateDiscount(cartList: cartList, discountType: DiscountType.campaign, daysCount: scheduleDaysCount);
//               double couponDisCount = CheckoutHelper.calculateDiscount(cartList: cartList, discountType: DiscountType.coupon, daysCount: applicableCouponCount);
//               double referDisCount = cartController.referralAmount;
//               double vat =  CheckoutHelper.calculateVat(cartList: cartList, daysCount: scheduleDaysCount);
//               double grandTotal = CheckoutHelper.calculateGrandTotal(cartList: cartList, referralDiscount: referDisCount, daysCount: scheduleDaysCount);
//               double dueAmount = CheckoutHelper.calculateDueAmount(cartList: cartList, walletPaymentStatus: walletPaymentStatus, walletBalance:cartController.walletBalance, bookingAmount: cartController.totalPrice, referralDiscount: referDisCount, daysCount: scheduleDaysCount);
//
//               Future.delayed(const Duration(milliseconds: 200), (){
//                 cartController.updateTotalPrice = grandTotal;
//                 cartController.update();
//               });
//
//               return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//                 Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
//                     child: Text( 'cart_summary'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault))
//                 ),
//
//                 Padding( padding: const EdgeInsets.all( Dimensions.paddingSizeDefault),
//                   child: Column( children: [
//                     ListView.builder(
//   itemCount: cartList.length,
//   shrinkWrap: true,
//   physics: const NeverScrollableScrollPhysics(),
//   itemBuilder: (context, index) {
//     double totalCost = (cartList[index].serviceCost.toDouble() * cartList[index].quantity) * scheduleDaysCount;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: RowText(
//                 title: cartList[index].service!.name!,
//                 quantity: cartList[index].quantity,
//                 price: totalCost,
//               ),
//             ),
//             Obx(() {
//               final isLoading = cartController.removingIndex.value == index;
//               return isLoading
//                   ? const SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
//                       onPressed: () {
//                         cartController.removeFromCartList(index);
//                       },
//                     );
//             }),
//           ],
//         ),
//         SizedBox(
//           width: Get.width / 2.5,
//           child: Text(
//             cartList[index].variantKey,
//             style: robotoMedium.copyWith(
//               color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4),
//               fontSize: Dimensions.fontSizeSmall,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(height: Dimensions.paddingSizeDefault),
//       ],
//     );
//   },
// ),
//                     Divider(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)),
//                     const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//
//                     RowText(title: 'sub_total'.tr, price: subTotalPrice),
//                     RowText(title: 'discount'.tr, price: disCount),
//                     RowText(title: 'campaign_discount'.tr, price: campaignDisCount),
//                     RowText(title: 'coupon_discount'.tr, price: couponDisCount),
//                     if(referDisCount > 0)
//                       RowText(title: 'referral_discount'.tr, price: referDisCount),
//                     RowText(title: 'vat'.tr, price: vat),
//
//                     (configModel.content?.additionalChargeLabelName != "" && configModel.content?.additionalCharge == 1) ?
//                     GetBuilder<CheckOutController>(builder: (controller){
//                       return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//                         Expanded(
//                           child: Row(children: [
//                             Flexible(child: Text(configModel.content?.additionalChargeLabelName ?? "", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),overflow: TextOverflow.ellipsis,)),
//
//                           ],),
//                         ),
//                         Text("(+) ${PriceConverter.convertPrice( additionalCharge, isShowLongPrice: true)}", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),)
//                       ],);
//                     }): const SizedBox(),
//
//                     Padding( padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//                       child: Divider(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)),
//                     ),
//
//                     RowText(title:'grand_total'.tr , price: grandTotal),
//                     (Get.find<CartController>().walletPaymentStatus) ? RowText(title:'paid_by_wallet'.tr , price: paidAmount) : const SizedBox(),
//                     (Get.find<CartController>().walletPaymentStatus && isPartialPayment) ? RowText(title:'due_amount'.tr , price: dueAmount) : const SizedBox(),
//                   ]),
//                 ),
//
//                 Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
//                   child: ConditionCheckBox(
//                     checkBoxValue: checkoutController.acceptTerms,
//                     onTap: (bool? value){
//                       checkoutController.toggleTerms();
//                     },
//                   ),
//                 ),
//
//               ]);
//             }
//         );
//       });
//     });
//   }
// }



/////////////


import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class CartSummery extends StatelessWidget {
  const CartSummery({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutController>(builder: (checkoutController) {
      return GetBuilder<ScheduleController>(builder: (scheduleController) {
        return GetBuilder<CartController>(builder: (cartController) {
          int scheduleDaysCount = scheduleController.scheduleDaysCount > 0
              ? scheduleController.scheduleDaysCount
              : 1;

          ConfigModel configModel = Get.find<SplashController>().configModel;
          List<CartModel> cartList = cartController.cartList;

          ////////////////////
          bool hasBlockedSubCategory = cartList.any(
                  (item) => item.subCategoryId == '1a5bf45c-9d32-4f4e-a726-126e1a40c836');

          bool walletPaymentStatus = cartController.walletPaymentStatus;
          int applicableCouponCount =
              CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                  pickedScheduleDays: scheduleDaysCount) ??
                  1;
          double additionalCharge = CheckoutHelper.getAdditionalCharge();
          bool isPartialPayment = CheckoutHelper.checkPartialPayment(
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice);
          double paidAmount = CheckoutHelper.calculatePaidAmount(
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice);
          double subTotalPrice = CheckoutHelper.calculateSubTotal(
              cartList: cartList, daysCount: scheduleDaysCount);
          double disCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.general,
              daysCount: scheduleDaysCount);
          double campaignDisCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.campaign,
              daysCount: scheduleDaysCount);
          double couponDisCount = CheckoutHelper.calculateDiscount(
              cartList: cartList,
              discountType: DiscountType.coupon,
              daysCount: applicableCouponCount);
          double referDisCount = cartController.referralAmount;
          double vat = CheckoutHelper.calculateVat(
              cartList: cartList, daysCount: scheduleDaysCount);
          double grandTotal = CheckoutHelper.calculateGrandTotal(
              cartList: cartList,
              referralDiscount: referDisCount,
              daysCount: scheduleDaysCount);
          double dueAmount = CheckoutHelper.calculateDueAmount(
              cartList: cartList,
              walletPaymentStatus: walletPaymentStatus,
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice,
              referralDiscount: referDisCount,
              daysCount: scheduleDaysCount);

          Future.delayed(const Duration(milliseconds: 200), () {
            cartController.updateTotalPrice = grandTotal;
            cartController.update();
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show cart summary only if not blocked
              if (!hasBlockedSubCategory)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Text('cart_summary'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                ),

              if (!hasBlockedSubCategory)
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: cartList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double totalCost =
                              (cartList[index].serviceCost.toDouble() *
                                  cartList[index].quantity) *
                                  scheduleDaysCount;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RowText(
                                      title: cartList[index].service!.name!,
                                      quantity: cartList[index].quantity,
                                      price: totalCost,
                                    ),
                                  ),
                                  Obx(() {
                                    final isLoading = cartController.removingIndex.value == index;
                                    return isLoading
                                        ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                        : IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        cartController.removeFromCartList(index);
                                      },
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(
                                width: Get.width / 2.5,
                                child: Text(
                                  cartList[index].variantKey,
                                  style: robotoMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.4),
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],
                          );
                        },
                      ),
                      Divider(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.6)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      RowText(title: 'sub_total'.tr, price: subTotalPrice),
                      RowText(title: 'discount'.tr, price: disCount),
                      RowText(title: 'campaign_discount'.tr, price: campaignDisCount),
                      RowText(title: 'coupon_discount'.tr, price: couponDisCount),
                      if (referDisCount > 0)
                        RowText(title: 'referral_discount'.tr, price: referDisCount),
                      RowText(title: 'vat'.tr, price: vat),
                      if ((configModel.content?.additionalChargeLabelName != "") &&
                          configModel.content?.additionalCharge == 1)
                        GetBuilder<CheckOutController>(
                            builder: (controller) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                                configModel.content
                                                    ?.additionalChargeLabelName ??
                                                    "",
                                                style: robotoRegular.copyWith(
                                                    fontSize:
                                                    Dimensions.fontSizeDefault),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        "(+) ${PriceConverter.convertPrice(additionalCharge, isShowLongPrice: true)}",
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault))
                                  ]);
                            }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeSmall),
                        child: Divider(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.6)),
                      ),
                      RowText(title: 'grand_total'.tr, price: grandTotal),
                      if (cartController.walletPaymentStatus)
                        RowText(title: 'paid_by_wallet'.tr, price: paidAmount),
                      if (cartController.walletPaymentStatus && isPartialPayment)
                        RowText(title: 'due_amount'.tr, price: dueAmount),
                    ],
                  ),
                ),

              // ✅ Always show the terms checkbox
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeSmall),
                child: ConditionCheckBox(
                  checkBoxValue: checkoutController.acceptTerms,
                  onTap: (bool? value) {
                    checkoutController.toggleTerms();
                  },
                ),
              )
            ],
          );
        });
      });
    });
  }
}
