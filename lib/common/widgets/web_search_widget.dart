import 'package:get/get.dart';
import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';

class SearchWidgetWeb extends GetView<AllSearchController> {
  final bool openSearchDialog;
  const SearchWidgetWeb({super.key, this.openSearchDialog = true}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(
      builder: (searchController){
        return Center(child: Padding(
            padding: const EdgeInsets.only(top:Dimensions.paddingSizeExtraSmall,left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault),
            child: SizedBox(
                height: Dimensions.searchbarSize,
                width: 350,
                child: TextField(
                  onTap: () {
                    if(Get.find<LocationController>().getUserAddress() !=null){
                      openSearchDialog ? Get.dialog(const SearchSuggestionDialog(), transitionCurve: Curves.fastOutSlowIn) : null;
                    }else{
                      Get.toNamed(RouteHelper.getPickMapRoute( "search_service" , false, 'false', null, null,));
                    }
                  } ,
                  controller: controller.searchController,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,
                  ),

                  cursorColor: Theme.of(context).hintColor,
                  autofocus: Get.isDialogOpen ?? false,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  onChanged: (text) {
                    searchController.showSuffixIcon(context,text);
                    if(text.trim().isNotEmpty) {
                      searchController.getSearchSuggestion(text);
                    }
                  },
                  onSubmitted: (value){
                  if (value.isNotEmpty) {
  if (value.length > 255) {
    showCustomSnackbar(
      title: 'Info',
      message: 'search_text_length_message'.tr,
      type: SnackbarType.info, // blue background with info icon
      position: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  } else {
    controller.navigateToSearchResultScreen();
  }
} else {
  showCustomSnackbar(
    title: 'Info',
    message: 'search_text_empty_message'.tr,
    type: SnackbarType.info,
    position: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}

                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    fillColor: Get.isDarkMode
                        ? Theme.of(context).hintColor.withValues(alpha: 0.2)
                        : Theme.of(context).primaryColorDark.withValues(alpha: 0.06),
                    isDense: true,
                    hintText: 'search_services_near_you'.tr,
                    hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    filled: true,
                    prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Icon(Icons.search,color: Theme.of(context).hintColor,),
                    ),
                    suffixIcon: searchController.isActiveSuffixIcon ? IconButton(
                      color: Get.isDarkMode? light.cardColor.withValues(alpha: 0.8) :Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        if(searchController.searchController.text.trim().isNotEmpty) {
                          Get.dialog(const CustomLoader(), barrierDismissible: false);
                          searchController.removeSortedItem(removeItem: AllFilterType.query, shouldUpdate: false);
                          await searchController.searchData(query: "", offset: 1, shouldUpdate: false, reload: false);
                          Get.back();
                        }
                      },
                      icon: const Icon(
                          Icons.cancel_outlined,
                      ),
                    ) : const SizedBox(),

                  ),
                )
            )));
      },
    );
  }
}
