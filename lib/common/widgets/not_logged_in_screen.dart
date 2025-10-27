import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class NotLoggedInScreen extends StatelessWidget {
  final String fromPage;
  final String appbarTitle;
  const NotLoggedInScreen({super.key, required this.fromPage, required this.appbarTitle}) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,

      appBar: CustomAppBar(title: appbarTitle.tr,),
      body: FooterBaseView(
        isCenter: true,
        child: WebShadowWrap(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(Images.guest,
                width: MediaQuery.of(context).size.height*0.25,
                height: MediaQuery.of(context).size.height*0.25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Text('sorry'.tr,
                style: robotoBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Text('you_are_not_logged_in'.tr,
                style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04),
              SizedBox(width: 200,
                child: CustomButton(buttonText: 'login_to_continue'.tr, height: 40, onPressed: () {
                  Get.toNamed(RouteHelper.getSignInRoute(fromPage : fromPage));
                }),
              ),

              SizedBox(height: Get.height*0.1,)

            ]),
          ),
        ),
      ),
    );
  }
}
