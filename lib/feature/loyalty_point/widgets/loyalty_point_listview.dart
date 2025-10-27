import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointListView extends StatelessWidget {
  const LoyaltyPointListView({super.key}) ;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GetBuilder<LoyaltyPointController>(builder: (loyaltyPointController){
      List<LoyaltyPointTransactionData> listOfTransaction = loyaltyPointController.listOfTransaction;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text('point_history'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge,),
          listOfTransaction.isNotEmpty?
          PaginatedListView(
            scrollController: scrollController,
            totalSize: loyaltyPointController.loyaltyPointModel!.content!.transactions!.total!,
            onPaginate: (int offset) async => await loyaltyPointController.getLoyaltyPointData(
              offset, reload: false,
            ),
            offset: loyaltyPointController.loyaltyPointModel!.content!.transactions?.currentPage,
            itemView: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isDesktop(context)?2:1,
                mainAxisExtent: 120,crossAxisSpacing: Dimensions.paddingSizeDefault),
              itemCount: listOfTransaction.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return LoyaltyPointItemView(transactionData: listOfTransaction[index],);
              },),
          ):NoDataScreen(text: 'no_transaction_yet'.tr,type: NoDataType.transaction,),
        ],),
      );
    });
  }
}

