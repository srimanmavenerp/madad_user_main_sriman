import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class SubCategoryWidget extends GetView<ServiceController> {
  final CategoryModel? categoryModel;
  const SubCategoryWidget({super.key, required this.categoryModel,});

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);

    return InkWell(
      // onTap: () {
      //   Get.find<ServiceController>().cleanSubCategory();
      //   Get.toNamed(RouteHelper.allServiceScreenRoute(categoryModel!.id!.toString()));
      // },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: Theme.of(context).cardColor,
            boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImage(
              image: categoryModel?.imageFullPath ?? "",
              height: 90, width: 90 , fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(children: [
                  Expanded(child: Text(
                    categoryModel?.name ?? "",
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                    maxLines: desktop ? 1 : 1, overflow: TextOverflow.ellipsis,
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text( categoryModel?.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                Text( "${categoryModel?.serviceCount ?? "" } ${'services'.tr} ",
                  style: robotoRegular.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}


//
// import 'package:get/get.dart';
//  import 'package:madaduser/utils/core_export.dart';
//
// import '../../vehicle/vehicle/view/vehicle_select_view.dart';
// class SubCategoryWidget extends StatelessWidget {
//   final CategoryModel categoryModel;
//   const SubCategoryWidget({Key? key, required this.categoryModel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to VehicleSelectView with selected subcategory id as serviceId
//         Get.to(() => VehicleSelectView(serviceId: categoryModel.id ?? ""));
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 4,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Example: show image and name
//             if (categoryModel.imageFullPath != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   categoryModel.imageFullPath!,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 categoryModel.name ?? '',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }