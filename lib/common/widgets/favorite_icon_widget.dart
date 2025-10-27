import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class FavoriteIconWidget extends StatefulWidget {
  final int? value;
  final String? serviceId;
  final String? providerId;
  final bool ? showDialog;
  final int? index;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final bool isTap;
  const FavoriteIconWidget({super.key,  this.value, this.serviceId, this.providerId, this.signInShakeKey, this.showDialog, this.index,  this.isTap = true}) ;

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isTap ? (){

        _controller.reverse().then((value) => _controller.forward());

        if(Get.find<AuthController>().isLoggedIn()){
         if(widget.showDialog == true){
           showModalBottomSheet(
             context: context,
             useRootNavigator: true,
             isScrollControlled: true,
             builder: (context) => FavoriteItemRemoveDialog(
               providerId : widget.providerId,
               serviceId: widget.serviceId,
             ),
             backgroundColor: Colors.transparent,
           );
         }else{
           if(widget.providerId !=null){
             Get.find<ProviderBookingController>().updateIsFavoriteStatus(providerId: widget.providerId!, index: widget.index);
           }else if(widget.serviceId != null){
             Get.find<ServiceController>().updateIsFavoriteStatus(
               serviceId: widget.serviceId!,
               currentStatus: widget.value ?? 0,
             );
           }

         }
        }else{
          widget.signInShakeKey?.currentState?.shake();
          showCustomSnackbar(
  title: 'Info',
  message: '', // message will be empty because mainButton contains the custom content
  type: SnackbarType.info,
  position: SnackPosition.BOTTOM,
  mainButton: TextButton(
    onPressed: () => Get.toNamed(RouteHelper.getSignInRoute()),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.info, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Text(
          "please_login_to_add_favorite_list".tr,
          style: const TextStyle(color: Colors.black), // matches your snackbar style
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 16),
        Text(
          'sign_in'.tr,
          style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
  duration: const Duration(seconds: 4),
);

        }
      } : null,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
          child: Image.asset(widget.value == 1 && Get.find<AuthController>().isLoggedIn() ? Images.favorite : Images.unFavorite, width: 23,),
        ),
      ),
    );
  }
}
