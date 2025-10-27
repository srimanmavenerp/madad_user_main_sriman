import 'package:madaduser/helper/route_helper.dart';
import 'package:madaduser/feature/auth/controller/auth_controller.dart';
import 'package:madaduser/feature/splash/controller/splash_controller.dart';
import 'package:madaduser/utils/dimensions.dart';
import 'package:madaduser/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveChatButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool isBorderActive;
  const LiveChatButton({super.key, required this.title, required this.iconData, required this.isBorderActive}) ;

  @override
  Widget build(BuildContext context) {
    final Uri launchUri =  Uri(
      scheme: 'tel',
      path: Get.find<SplashController>().configModel.content!.businessPhone.toString(),
    );
    return ElevatedButton(
      onPressed: () async {
        if(!isBorderActive) {

          if(Get.find<AuthController>().isLoggedIn()){
            Get.toNamed(RouteHelper.getInboxScreenRoute());
          }else{
            Get.toNamed(RouteHelper.getNotLoggedScreen(RouteHelper.chatInbox, 'inbox'));
          }

        } else{
          await launchUrl(launchUri,mode: LaunchMode.externalApplication);
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor:isBorderActive ? Colors.transparent : Theme.of(context).colorScheme.primary,
        side: BorderSide(color:Theme.of(context).colorScheme.primary), elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius:BorderRadius.all(Radius.circular(Dimensions.radiusSeven)
          ),
        ),

      ),
      child: Padding(padding: const EdgeInsets.all(10.0), child: Row(children: [

        Icon(iconData,color: isBorderActive ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColorLight, size: 17,),
        const SizedBox(width: Dimensions.paddingSizeTine,),

        Text(title,style: robotoRegular.copyWith(color:isBorderActive ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColorLight ))
      ])),
    );
  }
}
