


import 'package:get/get.dart';
import 'package:madaduser/feature/TypesofCarwash/TypesOfCarWash_screen.dart';
import 'package:madaduser/utils/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      if (categoryController.categoryList == null) {
        return const CategoryShimmer();
      }
      if (categoryController.categoryList!.isEmpty) {
        return const SizedBox();
      }

      // Copy the list to avoid mutating the original
      final categories = List.from(categoryController.categoryList!);

      // Move "Packages and Movers" to the end of the list
      final moversIndex = categories.indexWhere(
        (cat) => (cat.name ?? '').contains('Packers and Movers'),
      );
      if (moversIndex != -1) {
        final moversCategory = categories.removeAt(moversIndex);
        categories.add(moversCategory);
      }

      final labelTexts = [
        'Book',
        'Book',
       
        'Book', 'Coming soon',
        'Coming soon',
        'Coming soon',
      ];

      final labelColors = [
        Colors.purple,
        Colors.deepPurple,
        Colors.green,
        Colors.pink,
        Colors.orange,
        Colors.indigo,
      ];

      return Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                LayoutBuilder(builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth >= 1000) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth >= 600) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final label = labelTexts.length > index ? labelTexts[index] : 'Book';
                      final color = labelColors.length > index ? labelColors[index] : Colors.blueGrey;

                      return GestureDetector(
                        onTap: () => label != 'Coming soon'
                            ? Get.to(() => TypesOfCarWashView(categoryId: category.id!))
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: color.withOpacity(0.4)),
                            boxShadow: Get.isDarkMode ? null : cardShadow,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CustomImage(
                                      image: category.imageFullPath ?? "",
                                      fit: BoxFit.contain,
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                category.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  label,
                                  style: robotoMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const CategoryShimmer({super.key, this.fromHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if (fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeLarge),
            if (fromHomeScreen!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 25,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Get.find<ThemeController>().darkTheme
                          ? Theme.of(context).cardColor
                          : Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: Get.isDarkMode ? null : cardShadow,
                    ),
                  ),
                  Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Get.find<ThemeController>().darkTheme
                          ? Theme.of(context).cardColor
                          : Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: Get.isDarkMode ? null : cardShadow,
                    ),
                  ),
                ],
              ),
            if (fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeSmall),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: !fromHomeScreen!
                  ? 8
                  : ResponsiveHelper.isDesktop(context)
                      ? 10
                      : ResponsiveHelper.isTab(context)
                          ? 12
                          : 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).shadowColor,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                        ]),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: !fromHomeScreen!
                    ? 8
                    : ResponsiveHelper.isDesktop(context)
                        ? 10
                        : ResponsiveHelper.isTab(context)
                            ? 6
                            : 4,
                crossAxisSpacing: Dimensions.paddingSizeSmall + 2,
                mainAxisSpacing: Dimensions.paddingSizeSmall + 2,
                childAspectRatio: 1,
              ),
            ),
            SizedBox(
                height: ResponsiveHelper.isDesktop(context)
                    ? 0
                    : Dimensions.paddingSizeLarge)
          ],
        ),
      ),
    );
  }
}
