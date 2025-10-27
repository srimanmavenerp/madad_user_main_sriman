// import 'package:madaduser/common/models/user_model.dart';
// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
// class ServiceManInfo extends StatelessWidget {
//   final User user;
//   const ServiceManInfo({super.key,required this.user, }) ;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width:double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
//         color: Theme.of(context).hoverColor,
//       ),
//       padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
//       child: Column(
//         children: [
//           Padding(
//               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//               child: Text("service_man_info".tr, style: robotoMedium.copyWith(
//                   fontSize: Dimensions.fontSizeDefault,
//                   color:Get.isDarkMode? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6): Theme.of(context).primaryColor))),
//           Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
//
//           ClipRRect(
//             borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
//             child: SizedBox(
//               width: Dimensions.imageSize,
//               height: Dimensions.imageSize,
//               child:  CustomImage(image: user.profileImageFullPath ?? ""),
//
//             ),
//           ),
//           Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//           Text("${user.firstName ?? ""} ${user.lastName ?? ""}",style:robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,)),
//           Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//           Text(user.phone ?? "",style:robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,)),
//         ],
//       ),
//     );
//   }
// }



import 'package:madaduser/common/models/user_model.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceManInfo extends StatelessWidget {
  final User user;
  const ServiceManInfo({super.key, required this.user});

  Future<void> _launchDialer(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('Error', 'Could not launch phone dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        color: Theme.of(context).hoverColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text(
              "service_man_info".tr,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Get.isDarkMode
                    ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
            child: SizedBox(
              width: Dimensions.imageSize,
              height: Dimensions.imageSize,
              child: CustomImage(image: user.profileImageFullPath ?? ""),
            ),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Text(
            "${user.firstName ?? ""} ${user.lastName ?? ""}",
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),

          // Clickable phone number
          TextButton(
            onPressed: () => _launchDialer(user.phone),
            child: Text(
              user.phone ?? "",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}