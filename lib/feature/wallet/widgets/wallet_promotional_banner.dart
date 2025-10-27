import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class WalletPromotionalBannerView extends StatelessWidget {
  const WalletPromotionalBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return ((Get.find<SplashController>().configModel.content?.addFundToWallet == 0) || (walletController.bonusList != null && walletController.bonusList!.isEmpty)) ?
        const SizedBox() :
        SizedBox( width: MediaQuery.of(context).size.width, height: 130, child: walletController.bonusList != null ?
          Column( crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: walletController.bonusList!.length > 1,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  disableCenter: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    walletController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: walletController.bonusList!.isEmpty ? 1 : walletController.bonusList!.length,
                itemBuilder: (context, index, _) {
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: WalletBannerView(bonusModel: walletController.bonusList?[index],),
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            walletController.bonusList!.length > 1 ? Align( alignment: Alignment.center,
              child: AnimatedSmoothIndicator(
                activeIndex: walletController.currentIndex!,
                count: walletController.bonusList!.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Theme.of(context).disabledColor,
                ),
              ),
            ): const SizedBox(),
          ],) :
          Padding( padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.08))
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(height: 10, width: 20, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 10),

                      Container(height: 10, width: 50, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 10),
                      Container(height: 10, width: 70, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                    ]),

                  ],
                ),
              ),
        ),
          ));
      },
    );
  }
}
