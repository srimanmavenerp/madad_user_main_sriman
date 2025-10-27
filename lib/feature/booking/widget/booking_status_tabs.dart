import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class   ServiceRequestSectionMenu extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<ServiceBookingController>(builder: (serviceBookingController){
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.transparent : Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radiusLarge),
              bottomRight: Radius.circular(Dimensions.radiusLarge),
            ),
          ),
          child: Container(
            height: double.infinity, width: Dimensions.webMaxWidth,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                color: ResponsiveHelper.isDesktop(context) && Get.isDarkMode ?
                Theme.of(context).cardColor : ResponsiveHelper.isDesktop(context)
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.07) : Get.isDarkMode ? Colors.transparent
                    : Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusLarge),
                  bottomRight: Radius.circular(Dimensions.radiusLarge),
                )
            ),

            child: ResponsiveHelper.isDesktop(context) ? Column(
              mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const SizedBox(),
                Text('my_bookings'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),


                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  const SizedBox(),
                  Padding( padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight),
                    child: Wrap(alignment: WrapAlignment.center, children: BookingStatusTabs.values.map((e) {
                      return GetBuilder<ServiceBookingController>(builder: (controller){
                        return InkWell(
                          child: BookingStatusTabItem(
                            title: e.name,
                          ),
                          onTap: (){
                            controller.updateBookingStatusTabs(e);
                          },
                        );
                      },);
                    }
                    ).toList()),
                  ),
                  const FilterPopUpMenuWidget()
                ]),

              ],
            ) : Center(
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: BookingStatusTabs.values.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return GetBuilder<ServiceBookingController>(builder: (controller){
                      return InkWell(
                        child: BookingStatusTabItem(
                          title: BookingStatusTabs.values.elementAt(index).name,
                        ),
                        onTap: (){
                          controller.updateBookingStatusTabs(BookingStatusTabs.values.elementAt(index));
                        },
                      );
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  double get maxExtent => ResponsiveHelper.isDesktop(Get.context!)  ? 110 : 60;

  @override
  double get minExtent => ResponsiveHelper.isDesktop(Get.context!)  ? 110 : 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}