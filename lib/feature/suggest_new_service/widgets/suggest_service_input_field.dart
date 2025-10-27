import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class SuggestServiceInputField extends StatefulWidget {
  const SuggestServiceInputField({super.key}) ;

  @override
  State<SuggestServiceInputField> createState() => _SuggestServiceInputFieldState();
}

class _SuggestServiceInputFieldState extends State<SuggestServiceInputField> {

  final FocusNode _serviceName = FocusNode();
  final FocusNode _serviceDetails = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuggestServiceController>(builder: (suggestedServiceController){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

        TextFieldTitle(title: "service_category".tr,requiredMark: true),
        GetBuilder<CategoryController>(builder: (categoryController){
          return Container(width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all( color: Theme.of(context).hintColor)
            ),
            child: DropdownButtonHideUnderline(

              child: DropdownButton(

                  dropdownColor: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5), elevation: 2,

                  hint: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text(suggestedServiceController.selectedCategoryName==''?
                    "select_category".tr:suggestedServiceController.selectedCategoryName,
                      style: robotoRegular.copyWith(
                          color: suggestedServiceController.selectedCategoryName==''?
                          Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6):
                          Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8)
                      ),
                    ),
                  ),
                  icon: const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                  items: categoryController.categoryList?.map((CategoryModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Row(
                        children: [
                          Text(items.name ?? "",
                            style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (CategoryModel? newValue) => suggestedServiceController.setIdentityType(newValue)
              ),
            ),
          );
        }),

        TextFieldTitle(title:"service_name".tr),

        CustomTextField(
          hintText: 'service_name'.tr,
          controller: suggestedServiceController.serviceNameController,
          inputType: TextInputType.text,
          inputAction: TextInputAction.next,
          isShowBorder: true,
          focusNode: _serviceName,
          nextFocus: _serviceDetails,
        ),

        TextFieldTitle(title:"provide_some_details".tr),
        CustomTextField(
          hintText: "write_something".tr,
          inputType: TextInputType.text,
          maxLines: 2,
          isShowBorder: true,
          focusNode: _serviceDetails,
          inputAction: TextInputAction.done,
          controller: suggestedServiceController.serviceDetailsController,
        ),
      ],
      );
    });
  }
}
