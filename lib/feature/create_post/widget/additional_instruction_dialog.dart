import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class AdditionalInstructionDialog extends StatelessWidget {
  const AdditionalInstructionDialog({super.key,}) ;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<CreatePostController>(
          builder: (createPostController) {
        return SizedBox(
          width: Dimensions.webMaxWidth/1.5,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [

                const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

                Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('add_additional_instruction'.tr,style:  robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary
                    ),),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge,)
                  ]),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
                  child: CustomTextFormField(
                    hintText: "write_something".tr,
                    inputType: TextInputType.text,
                    controller: createPostController.additionalInstructionController,
                    //controller: additionalInstructionController,
                    maxLines: 3,
                    isShowBorder: true,
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child: CustomButton(
                    buttonText: "add".tr, height: ResponsiveHelper.isDesktop(context)? 40 : 35, width: ResponsiveHelper.isDesktop(context)? 100 :  80,
                    radius: Dimensions.radiusExtraMoreLarge,
                    fontSize: Dimensions.fontSizeDefault,
                    onPressed: (){
                      String value = createPostController.additionalInstructionController.text;
                      if(value.isNotEmpty){
                        createPostController.addAdditionalInstruction(value);
                      }else{
                        customSnackBar('enter_additional_instruction'.tr, type: ToasterMessageType.info);
                      }
                      Get.back();
                    },
                  ),
                ),
              ]),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: GestureDetector(
                  onTap: (){
                    Get.find<CreatePostController>().additionalInstructionController.text = '';
                    Get.back();
                    },

                  child: Icon(Icons.close,size: 25,color: Colors.deepPurple,),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
