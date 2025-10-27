import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final TextDecoration? textDecoration;
  final Function()? onTap;
  const TitleWidget({super.key, required this.title, this.onTap, this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Flexible(
        child: Text(title!.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: title=='recently_view_services'
            ? Colors.white:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .8),
        ),maxLines: 1,overflow: TextOverflow.ellipsis,),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall,),
      (onTap != null) ? InkWell(
        onTap: onTap,
        child: Text(''.tr,
          style: robotoRegular.copyWith(
            decoration: textDecoration,
            color:Get.isDarkMode ?Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .8):
            title=='recently_view_services'? Colors.white : Theme.of(context).colorScheme.primary,
            fontSize: Dimensions.fontSizeLarge,
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
