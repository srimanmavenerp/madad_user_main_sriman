import 'package:madaduser/common/models/language_model.dart';
import 'package:madaduser/common/widgets/ripple_button.dart';
import 'package:madaduser/feature/language/controller/localization_controller.dart';
import 'package:madaduser/feature/splash/controller/theme_controller.dart';
import 'package:madaduser/utils/dimensions.dart';
import 'package:madaduser/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  const LanguageWidget({super.key,
    required this.languageModel,
    required this.localizationController,
    required this.index,
  }) ;

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = localizationController.isLtr ? 0 : 1;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              color:Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow
          ),
          child: Stack(children: [
            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: 65, width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .2), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),

                    child: Image.asset(
                      languageModel.imageUrl!, width: 36, height: 36,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(languageModel.languageName!, style: robotoRegular),
              ]),
            ),
            localizationController.selectedIndex == index ? Positioned(
              top: 0, right: 0,
              child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 25),
            ) : const SizedBox(),
          ]),
        ),
        Positioned.fill(child: RippleButton(onTap: () {
          localizationController.setSelectIndex(index);
        }))
      ],
    );
  }
}
