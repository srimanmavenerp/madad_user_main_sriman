import 'package:madaduser/utils/core_export.dart';
import 'package:madaduser/feature/area/widget/my_marker.dart';
import 'package:get/get.dart';


class AreaMapViewScreen extends StatefulWidget {
  final List<ZoneModel> zoneList;
  final Function(bool)? onValueChanged;
  const AreaMapViewScreen({super.key, required this.zoneList,  this.onValueChanged});
  @override
  State<AreaMapViewScreen> createState() => _AreaMapViewScreenState();
}

class _AreaMapViewScreenState extends State<AreaMapViewScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  LatLng? _initialPosition;


  Map<String, GlobalKey> globalKeyMap = {};

  @override
  void initState() {
    super.initState();

    _initialPosition = LatLng(
      Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.0000,
      Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.0000,
    );

    for(int index = 0; index< widget.zoneList.length ; index++){
      globalKeyMap.addAll({
        index.toString() : GlobalKey()
      });
    }
  }

  void _onPanStart() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(true);
      });
    }
  }
  void _onPanEnd() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ServiceAreaController>(
          builder: (serviceAreaController) {
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Stack(
                  children: [

                    ListView.builder(itemBuilder: (context, index){
                      return  MyMarker(globalKeyMap[index.toString()]! , zone: widget.zoneList[index],);
                    }, itemCount: serviceAreaController.zoneList?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ) ,

                    Container(color: Theme.of(context).scaffoldBackgroundColor,),

                    MouseRegion(
                      onEnter: (event) => _onPanStart(),
                      onExit: (event) => _onPanEnd(),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: _initialPosition!, zoom: 4),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        onMapCreated: (GoogleMapController mapController) {
                          _controller.complete(mapController);
                          _mapController = mapController;
                          if (kDebugMode) {
                           print("Map : $_mapController");
                          }
                          Future.delayed(const Duration(milliseconds: 100));
                          serviceAreaController.setMarker(widget.zoneList, globalKeyMap).then((value) => serviceAreaController.mapBound(mapController));
                        },
                        style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                        zoomControlsEnabled: ResponsiveHelper.isDesktop(context) ? true : false,
                        myLocationButtonEnabled: false,
                        markers: serviceAreaController.markers,
                        polygons: serviceAreaController.polygone,


                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}