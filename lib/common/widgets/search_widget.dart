import 'package:get/get.dart';
import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';

class SearchWidget extends StatelessWidget {
   const SearchWidget({super.key}) ;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(
      builder: (searchController){
        return Center(child: Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeSmall),
          child: SizedBox(
            height: Dimensions.searchbarSize,
            child: TextField(
              controller: searchController.searchController,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
              ),
              cursorColor: Theme.of(context).hintColor,
              autofocus: false,
              focusNode: searchController.searchFocus,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 22),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(20,),left: Radius.circular(20)),
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                ),
                fillColor: Get.isDarkMode? Theme.of(context).primaryColorDark:const Color(0xffFEFEFE),
                isDense: true,
                hintText: 'search_services'.tr,
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor),
                filled: true,
                prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                suffixIcon: searchController.isActiveSuffixIcon ? IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    if(searchController.searchController.text.trim().isNotEmpty) {
                      Get.dialog(const CustomLoader(), barrierDismissible: false);
                      searchController.removeSortedItem(removeItem: AllFilterType.query, shouldUpdate: false);
                      await searchController.searchData(query: "", offset: 1, shouldUpdate: false, reload: false);
                      Get.back();
                    }
                    searchController.searchFocus.unfocus();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ) : const SizedBox(),
              ),
              onChanged: (text) {
                if(text.isEmpty){
                  searchController.searchFocus.unfocus();
                }
                searchController.showSuffixIcon(context,text);
              },
              onSubmitted: (text) {
                if (text.isNotEmpty) {
  if (text.length > 255) {
    showCustomSnackbar(
      title: 'Info',
      message: 'search_text_length_message'.tr,
      type: SnackbarType.info, // info styling with blue background and icon
      position: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  } else {
    searchController.searchData(query: text, offset: 1);
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

              },
            ),
          ),
        ),);
      },
    );
  }
}
