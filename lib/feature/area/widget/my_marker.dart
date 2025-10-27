import 'package:madaduser/utils/core_export.dart';


class MyMarker extends StatelessWidget {
  final GlobalKey globalKeyMyWidget;
  final ZoneModel zone;
  const MyMarker(this.globalKeyMyWidget, {super.key, required this.zone});


  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Column(
        children: [

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
            child: Text(zone.name ?? "", style: robotoMedium.copyWith(
                fontSize: ResponsiveHelper.isMobile(context) ? 20 : Dimensions.fontSizeSmall, color: Colors.black
            ),),
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall-2,),

          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [

              Image.asset(Images.marker,
                width: ResponsiveHelper.isMobile(context)? 50 : 25, fit: BoxFit.fitWidth,
              ),

            ],
          ),
        ],
      ),
    );
  }
}