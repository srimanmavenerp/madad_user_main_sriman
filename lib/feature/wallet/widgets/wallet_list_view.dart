import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class WalletListView extends StatelessWidget {
  final ScrollController scrollController;

  const WalletListView({super.key, required this.scrollController}) ;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WalletController>(builder: (walletController){

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          const SizedBox(height: Dimensions.paddingSizeDefault+5,),
          Row(children: [
            Expanded(child: Text('wallet_history'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge ,color: Theme.of(context).textTheme.bodyLarge!.color),)),
            const SizedBox(width: Dimensions.paddingSizeSmall,),

             PopupMenuButton<WalletFilterBody>(
              onSelected: (WalletFilterBody body) {
                walletController.updateWalletFilterValue(body);
                walletController.getWalletTransactionData(1, reload: true , type: body.value ?? "");
              },
               itemBuilder: (BuildContext context) {
                 return walletController.walletFilterList.map((WalletFilterBody option) {
                   return PopupMenuItem<WalletFilterBody>(
                     value: option,
                     child: Text(option.title?.tr??""),
                   );
                 }).toList();
               },
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                   border: Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7), width: 0.8)
                 ),
                 padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall-2),
                 child: Row(children: [
                   const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                   Text( walletController.selectedWalletFilter?.title?.tr?? 'filter'.tr ,
                     style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                   ),
                   Icon(Icons.arrow_drop_down_outlined, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                 ],),
               ),
            ),
          ],),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge+5,),

          walletController.listOfTransaction != null && walletController.listOfTransaction!.isNotEmpty ?
          PaginatedListView(
            scrollController: scrollController,
            totalSize: walletController.walletTransactionModel!.content!.transactions!.total!,
            onPaginate: (int offset) async => await walletController.getWalletTransactionData(
              offset, reload: false, type: walletController.selectedWalletFilter?.value ?? ""
            ),
            offset: walletController.walletTransactionModel!.content!.transactions?.currentPage,

            itemView: ListView.builder(
              itemCount: walletController.listOfTransaction?.length,
              itemBuilder: (context,index){
                return WalletListItem( transactionData: walletController.listOfTransaction![index],);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),

          ): walletController.listOfTransaction == null ? const WalletShimmer() :

          NoDataScreen(text: 'no_transaction_yet'.tr,type: NoDataType.transaction,),

        ],),
      );
    });
  }
}

