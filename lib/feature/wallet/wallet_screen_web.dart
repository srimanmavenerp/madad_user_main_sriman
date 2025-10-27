import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class WalletScreenWeb extends StatelessWidget {
  final JustTheController tooltipController;
  final ScrollController scrollController;
  const WalletScreenWeb({super.key, required this.scrollController, required this.tooltipController}) ;

  @override
  Widget build(BuildContext context) {
    return FooterBaseView(
      child: GetBuilder<WalletController>(builder: (walletController){

        return Center(
          child: SizedBox(width: Dimensions.webMaxWidth, child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Expanded(flex: 2,child: WebShadowWrap(child: Column(children: [

              WalletTopCard(tooltipController: tooltipController,),
              const WalletUsesManualDialog(),
              const SizedBox(height: 190,)

            ]))),
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            Expanded(flex: 3,child: Column(children: [

              WalletWebPromotionalBannerView(),

              WebShadowWrap( maxHeight: Get.height * 0.7, child: Column(children: [
                const SizedBox(height: Dimensions.paddingSizeSmall,),
                Row(children: [
                  Expanded(child: Text('wallet_history'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge ,color: Theme.of(context).textTheme.bodyLarge!.color),)),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),

                  PopupMenuButton<WalletFilterBody>(
                    onSelected: (WalletFilterBody body) {
                      walletController.updateWalletFilterValue(body);
                      walletController.getWalletTransactionData(1, reload: true, type: body.value ?? "" );
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
                        Text( walletController.selectedWalletFilter?.title?.tr ?? 'filter'.tr ,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                        ),
                        Icon(Icons.arrow_drop_down_outlined, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                      ],),
                    ),
                  ),
                ],),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge + 5,),

                walletController.listOfTransaction != null && walletController.listOfTransaction!.isNotEmpty ?
                Expanded(
                  child: PaginatedListView(
                    scrollController: scrollController,
                    totalSize: walletController.walletTransactionModel!.content!.transactions!.total!,
                    onPaginate: (int offset) async => await walletController.getWalletTransactionData(
                      offset, reload: false, type: walletController.selectedWalletFilter?.value ?? ""
                    ),
                    offset: walletController.walletTransactionModel!.content!.transactions?.currentPage,
                    bottomPadding: 0,
                    itemView: Expanded(
                      child: ListView.builder(
                        itemCount: walletController.listOfTransaction!.length,
                        itemBuilder: (context,index){
                          return WalletListItem( transactionData: walletController.listOfTransaction![index],);
                        },

                      ),
                    ),

                  ),
                ): walletController.listOfTransaction == null ? const Expanded(child: WalletShimmer()) :

                NoDataScreen(text: 'no_transaction_yet'.tr,type: NoDataType.transaction,),
              ],))
            ]))
          ])),
        );
      }),
    );
  }
}
