/*
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderData ? provider;
  const ProviderInfo({super.key, required this.provider}) ;

  @override
  Widget build(BuildContext context) {

    return Container(
      width:double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        color: Theme.of(context).hoverColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column( children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Text("provider_info".tr, style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: SizedBox(
            width: Dimensions.imageSize,
            height: Dimensions.imageSize,
            child: CustomImage(image: provider?.logoFullPath ?? "", placeholder: Images.userPlaceHolder),
          ),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        if(provider?.companyName !=null) Text(provider?.companyName ??"",style:robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,)),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        Text(provider == null ? "no_provider_assigned".tr : provider?.companyPhone ?? "",
          style:robotoRegular.copyWith(
            fontSize: provider == null ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
          ),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
*/


import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderData ? provider;
  const ProviderInfo({super.key, required this.provider}) ;

  @override
  Widget build(BuildContext context) {

    return Container(
      width:double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        color: Theme.of(context).hoverColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column( children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Text("provider_info".tr, style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: SizedBox(
            width: Dimensions.imageSize,
            height: Dimensions.imageSize,
            child: CustomImage(image: provider?.logoFullPath ?? "", placeholder: Images.userPlaceHolder),
          ),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        if(provider?.companyName !=null) Text(provider?.companyName ??"",style:robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,)),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        // Text(provider == null ? "no_provider_assigned".tr : provider?.companyPhone ?? "",
        //   style:robotoRegular.copyWith(
        //     fontSize: provider == null ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
        //   ),
        // ),

        TextButton(
          onPressed: () async {
            final phone = provider?.companyPhone ?? '';
            final Uri url = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              // Handle error or show a message
              Get.snackbar('Error', 'Could not launch phone dialer');
            }
          },
          child: Text(
            provider == null ? "no_provider_assigned".tr : provider?.companyPhone ?? "",
            style: robotoRegular.copyWith(
              fontSize: provider == null ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
      ]),
    );
  }
}