import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class WalletListItem extends StatelessWidget {
  final LoyaltyPointTransactionData transactionData;
  const  WalletListItem({super.key, required this.transactionData}) ;

  @override
  Widget build(BuildContext context) {

    String transactionType;
    if(transactionData.toUserAccount!=null && transactionData.toUserAccount=="balance_pending"){
      transactionType = transactionData.toUserAccount!.tr;
    }else{
      transactionType = transactionData.trxType.toString().tr;
    }

    double transactionAmount = transactionData.debit!=null && transactionData.debit!=0
        ? transactionData.debit?? 0 : transactionData.credit??0;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Flexible(
          child: Tooltip(
            message: transactionData.id,
            child: Row(
              children: [
                Text('XID  '.tr,
                  overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                  ),
                ),
          
                Flexible(
                  child: Text('${transactionData.id}',
                    overflow: TextOverflow.ellipsis,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Text(DateConverter.dateMonthYearTimeTwentyFourFormat(DateConverter.isoUtcStringToLocalDate(transactionData.createdAt!)),
            textDirection: TextDirection.ltr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).secondaryHeaderColor),
          ),
        )
      ]),
      Row(children: [
        SizedBox(height:90 ,width: 13,child: CustomDivider(height: 5,dashWidth: 0.7,axis: Axis.vertical,color: Get.isDarkMode?Colors.grey:Theme.of(context).colorScheme.primary,)),
        const SizedBox(width: Dimensions.paddingSizeSmall,),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).hintColor,width: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text(transactionType.tr,style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),),

                  Text.rich(
                    TextSpan(text: transactionData.debit!=0?"- ${PriceConverter.convertPrice(transactionAmount).replaceAll("-", "")}":"+ ${PriceConverter.convertPrice(transactionAmount)}",
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                        color:transactionData.debit!=0?Theme.of(context).colorScheme.error :Colors.green,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),
              const Divider()
            ],
          ),
        ),
      ],),
    ]);
  }
}
