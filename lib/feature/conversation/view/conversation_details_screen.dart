import 'package:madaduser/feature/conversation/widgets/conversation_bubble_widget.dart';
import 'package:madaduser/feature/conversation/widgets/conversation_details_appbar.dart';
import 'package:madaduser/feature/conversation/widgets/conversation_details_shimmer.dart';
import 'package:madaduser/feature/conversation/widgets/conversation_send_message_widget.dart';
import 'package:madaduser/feature/conversation/widgets/empty_conversation_widget.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';



class ConversationDetailsScreen extends StatefulWidget {
  final String? channelID;
  final String? name;
  final String? image;
  final String? phone;
  final String bookingID;
  final String userType;
  final String formNotification;

  const ConversationDetailsScreen({super.key,
    this.name,
    this.image,
    this.channelID,
     this.phone,
    this.bookingID = "",
    this.formNotification = "",
    this.userType =""});
  @override
  State<ConversationDetailsScreen> createState() => _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {

  String phone ='';
  String customerID = Get.find<UserController>().userInfoModel?.id?? '';

  @override
  void initState() {
    super.initState();
    Get.find<ConversationController>().cleanOldData();
    Get.find<ConversationController>().setChannelId(widget.channelID ?? "");
    Get.find<ConversationController>().getConversation(widget.channelID ??"", 1,isInitial:true);

    if(Get.find<SplashController>().configModel.content?.phoneNumberVisibility==0 && widget.userType.contains("provider-admin")){
      phone = "";
    }else{
      phone = "+${widget.phone}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: (){
        Get.offAllNamed(RouteHelper.getInboxScreenRoute(fromNotification: widget.formNotification));
      },
      child: Scaffold(

        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: ResponsiveHelper.isWeb() ?
        PreferredSize(
          preferredSize: Size(Dimensions.webMaxWidth, ResponsiveHelper.isDesktop(Get.context) ? Dimensions.preferredSizeWhenDesktop : Dimensions.preferredSize ),
            child: const CustomAppBar(title: "",)) :
        PreferredSize(
          preferredSize: const Size(double.maxFinite, 55),
          child: ConversationDetailsAppBar(
            fromNotification: widget.formNotification,
            name: widget.name, phone: phone, image: widget.image,
          ),
        ),


        body: FooterBaseView(
          isScrollView:(!ResponsiveHelper.isTab(context) && !ResponsiveHelper.isMobile(context) && ResponsiveHelper.isWeb())  ? true: false,
          child: WebShadowWrap(
            child: widget.channelID == null ?  const EmptyConversationWidget(fromSearch: false,) : GetBuilder<ConversationController>(builder: (conversationController) {
              if(conversationController.conversationList != null){
                List<ConversationData> conversationList = conversationController.conversationList!;

                return SizedBox(
                  height:(!ResponsiveHelper.isTab(context) && !ResponsiveHelper.isMobile(context) && ResponsiveHelper.isWeb()) ? 500 : null,

                  child: Column(
                    children: [

                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      if(ResponsiveHelper.isWeb() && !ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context))
                      Text(widget.name ??"", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .5),
                        ), textDirection: TextDirection.ltr,
                      ),

                      if(ResponsiveHelper.isWeb() && !ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context))
                        const SizedBox(height: Dimensions.paddingSizeSmall,),

                      if(ResponsiveHelper.isWeb() && !ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context))
                        Text(widget.userType=="provider"
                            && Get.find<SplashController>().configModel.content?.phoneNumberVisibility==0?"":"+${widget.phone}",
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .5)),
                        textDirection: TextDirection.ltr,
                      ),

                      Expanded(child:conversationList.isNotEmpty ? ListView.builder(
                        controller: conversationController.messageScrollController,
                        itemCount:  conversationList.length,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        reverse: true,
                        itemBuilder: (context,index){
                          bool isRightMessage = conversationList[index].userId == customerID;
                          return ConversationBubbleWidget(
                            image: widget.image,
                            name: widget.name,
                            conversationData: conversationList[index],
                            isRightMessage: isRightMessage,
                            previousConversationData: index == 0  ?
                            null : conversationController.conversationList?.elementAt(index-1),
                            nextConversationData: index == (conversationList.length - 1)  ? null : conversationList.elementAt(index+1),
                          );
                        },): SizedBox(child: Center(child: Text('no_conversation_yet'.tr)),),
                      ),

                      ConversationSendMessageWidget(channelId: widget.channelID ??""),

                    ],
                  ),
                );
                }else{
                return SizedBox(
                  height: ResponsiveHelper.isWeb() ? 500 : null,
                  child: const ConversationDetailsShimmer(),
                );
              }},
            ),
          ),
        ),
      ),
    );
  }
}
