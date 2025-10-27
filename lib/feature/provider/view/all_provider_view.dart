import 'package:madaduser/utils/core_export.dart';
import 'package:madaduser/feature/provider/widgets/provider_filter_view.dart';
import 'package:madaduser/feature/provider/widgets/provider_item_view.dart';
import 'package:get/get.dart';

class AllProviderView extends StatefulWidget {
  const AllProviderView({super.key}) ;

  @override
  State<AllProviderView> createState() => _AllProviderViewState();
}


class _AllProviderViewState extends State<AllProviderView> {

  @override
  void initState() {
    super.initState();
    _loadDart();
  }
  _loadDart() async {
    await Get.find<CategoryController>().getCategoryList( false);
    Get.find<ProviderBookingController>().resetProviderFilterData();
    Get.find<ProviderBookingController>().getProviderList(1, true);
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: 'provider_list'.tr,
        actionWidget: InkWell(onTap: (){
          showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context, builder: (context) => const ProviderFilterView());
          },

          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Image.asset(Images.filter,width: 20,color: Colors.white,),
          ),
        ),
      ),

      body: GetBuilder<ProviderBookingController>(builder: (providerBookingController){
        return FooterBaseView(
          isScrollView:true,
          scrollController: scrollController,
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(ResponsiveHelper.isDesktop(context))
                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault,horizontal: Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: (){
                      showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context, builder: (context) => const ProviderFilterView(),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeSmall),
                      child: Row(mainAxisSize: MainAxisSize.min,children: [
                        Image.asset(Images.filter,width: 20,color: Colors.white,),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text('filter'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.white),)
                      ],),
                    ),
                  ),
                ),

                providerBookingController.providerModel!=null && providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty?
                PaginatedListView(
                  scrollController: scrollController,
                  totalSize: providerBookingController.providerModel!.content!.total!,
                  onPaginate: (int offset) async => await providerBookingController.getProviderList(
                    offset, false,
                  ),
                  offset: providerBookingController.providerModel?.content?.currentPage,
                  itemView: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isDesktop(context)?3:ResponsiveHelper.isTab(context)?2:1,
                    mainAxisExtent: ResponsiveHelper.isDesktop(context)?180:ResponsiveHelper.isTab(context)?170:160
                  ),
                    itemCount: providerBookingController.providerList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return ProviderItemView(fromHomePage: false,providerData: providerBookingController.providerList![index], index: index,);
                    },),
                ) : (providerBookingController.providerModel == null || providerBookingController.providerList == null) ?
                SizedBox( height : ResponsiveHelper.isDesktop(context)? Get.height * 0.75 : Get.height * 0.9 , child: const ProviderListViewShimmer()):
                SizedBox(height: ResponsiveHelper.isDesktop(context)? Get.height*0.5:Get.height*0.9,
                    child: Center(
                        child: Text('no_provider_found'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.titleSmall!.color!.withValues(alpha: 0.7)),)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}


class ProviderListViewShimmer extends StatelessWidget {
  const ProviderListViewShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 180 : ResponsiveHelper.isTab(context) ? 170 : 160,
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
      ),
      itemBuilder: (context, index){
        return Shimmer(
          duration: const Duration(seconds: 1),
          interval: const Duration(seconds: 1),
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 5 : 2, vertical: Dimensions.paddingSizeEight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Image.asset(Images.userPlaceHolder, height: 60, width: 60,),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Container(height: 15, width: 100, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).shadowColor,
                    ),),
                    const SizedBox(height: 5),
                    Container(height: 10, width: 130,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).shadowColor,
                    )),
                  ]),

                  const Expanded(child: SizedBox()),
                  Icon(Icons.favorite, size: 20, color: Theme.of(context).shadowColor,)
                ]),

                const SizedBox(height: 10),
                Container(height: 12,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                )),

                const SizedBox(height: 5),
                Container(height: 12,  width: 200,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                )),
              ],
            ),
          ),
        );
      },
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shrinkWrap: true,
    );
  }
}

