import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class PostDetailsExpandableContent extends StatelessWidget {
 final MyPostData postData;
  const  PostDetailsExpandableContent({super.key, required this.postData}) ;

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: Dimensions.webMaxWidth,
      child: Stack(clipBehavior: Clip.none,alignment: Alignment.topCenter,children: [
        Container(decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20),
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              const Row(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: Dimensions.paddingSizeExtraSmall , width: 30,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                    image: postData.service?.thumbnailFullPath??"",
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeDefault,),
                Expanded( child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,children: [
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                    Text(postData.service?.name??"", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(postData.subCategory?.name??"",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)),),
                  ],),
                ),
                GetBuilder<CreatePostController>(builder: (createPostController){
                  return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault,left: 10,right: 10),
                    child: Stack(clipBehavior: Clip.none,children: [
                      Image.asset(Images.personIcon,height: 35,width: 35,),

                      createPostController.providerOfferModel != null ?
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                          height: 20, width: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.error
                          ),
                          child: FittedBox(
                            child: Text("${createPostController.providerOfferModel?.content?.total ?? "0"}", style: robotoRegular.copyWith(color: light.cardColor),
                            )
                          ),
                        ),
                      ) : const SizedBox()
                    ]),
                  );
                })
              ],),

              const SizedBox(height: Dimensions.paddingSizeLarge,),

              Text("description".tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).secondaryHeaderColor),),

              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Text(postData.serviceDescription??"",
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8)),),
              if(postData.additionInstructions!=null && postData.additionInstructions!.isNotEmpty)
              Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child: Text("additional_instruction".tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).secondaryHeaderColor),),
                ),

                ListView.builder(itemBuilder: (context,index){
                  return Container(decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Text(postData.additionInstructions![index].details??"",style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).colorScheme.primary
                    ),),
                  );
                },shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postData.additionInstructions!.length,
                )],
              )
            ],),
          ),
        ),
        
        if(!ResponsiveHelper.isDesktop(context))
        Positioned(top: -15,
          child: Container(height: 20,width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(150)),
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
            ),
            child: Icon(Icons.keyboard_arrow_up,color: Theme.of(context).colorScheme.primary,),
          ),
        ),
        if(!ResponsiveHelper.isDesktop(context))
        Positioned(top: 2,child: Container(
          height: 5,width: 60,decoration: BoxDecoration(
          color: Theme.of(context).cardColor
        ),
        ))
      ])),
    );
  }
}
