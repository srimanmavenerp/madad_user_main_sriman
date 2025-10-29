import 'package:madaduser/feature/home/widget/category_view.dart';

import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:in_app_update/in_app_update.dart';

class HomeScreen extends StatefulWidget {
  static Future<void> loadData(
    bool reload, {
    int availableServiceCount = 1,
  }) async {
    if (availableServiceCount == 0) {
      Get.find<BannerController>().getBannerList(reload);
    } else {
      await Future.wait([
        Get.find<ServiceController>().getRecommendedSearchList(),
        Get.find<ServiceController>().getAllServiceList(1, reload),
        Get.find<BannerController>().getBannerList(reload),
        Get.find<AdvertisementController>().getAdvertisementList(reload),
        Get.find<CategoryController>().getCategoryList(reload),
        //Get.find<ServiceController>().getPopularServiceList(1, reload),
        Get.find<ServiceController>().getTrendingServiceList(1, reload),
        Get.find<ProviderBookingController>().getProviderList(1, reload),
        Get.find<NearbyProviderController>().getProviderList(1, reload),
        Get.find<CampaignController>().getCampaignList(reload),
        Get.find<ServiceController>().getRecommendedServiceList(1, reload),
        Get.find<CheckOutController>().getOfflinePaymentMethod(
          false,
          shouldUpdate: false,
        ),
        Get.find<ServiceController>().getFeatherCategoryList(reload),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<AuthController>().updateToken(),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<ServiceController>().getRecentlyViewedServiceList(1, reload),
      ]);

      Get.find<BookingDetailsController>().manageDialog();
    }
  }

  final AddressModel? addressModel;
  final bool showServiceNotAvailableDialog;
  final UserInfoModel? userInfoModel;

  const HomeScreen({
    super.key,
    this.addressModel,
    required this.showServiceNotAvailableDialog,
    this.userInfoModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AddressModel? _previousAddress;
  int availableServiceCount = 0;
  bool _hasCheckedRatingDialog = false; // Flag to prevent multiple checks
  bool _isRetryingCustomerId =
      false; // Flag to track if we're currently retrying
  int _customerIdRetryCount = 0; // Counter for retries
  static const int _maxRetries = 5; // Maximum number of retries
  Timer? _customerIdRetryTimer; // Timer for retry mechanism
  AppUpdateInfo? _updateInfo;

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      setState(() => _updateInfo = info);

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // Immediate or flexible update
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("In-app update check failed: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      this,
    ); // Add observer for lifecycle changes

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);

    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }

    if (Get.find<LocationController>().getUserAddress() != null) {
      availableServiceCount = Get.find<LocationController>()
          .getUserAddress()!
          .availableServiceCountInZone!;
    }

    HomeScreen.loadData(false, availableServiceCount: availableServiceCount);
    _previousAddress = widget.addressModel;

    // Delay the rating dialog check to ensure it only runs once after initialization
    _checkForUpdate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    _customerIdRetryTimer?.cancel(); // Cancel any pending timers
    super.dispose();
  }

  Future<String?> _getCustomerId() async {
    String? customerId = Get.find<UserController>().userInfoModel?.id;

    if (customerId == null || customerId.isEmpty) {
      debugPrint(
        'Customer ID is null or empty, attempting to refresh user info',
      );

      await Get.find<UserController>().getUserInfo();
      customerId = Get.find<UserController>().userInfoModel?.id;

      debugPrint('After refresh, customer ID: ${customerId ?? "still null"}');
    }

    return customerId;
  }

  homeAppBar({GlobalKey<CustomShakingWidgetState>? signInShakeKey}) {
    if (ResponsiveHelper.isDesktop(context)) {
      return WebMenuBar(signInShakeKey: signInShakeKey);
    } else {
      return AddressAppBar(
        backButton: false,
        //userInfoModel: widget.userInfoModel,
      );
    }
  }

  final ScrollController scrollController = ScrollController();
  final signInShakeKey = GlobalKey<CustomShakingWidgetState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: homeAppBar(signInShakeKey: signInShakeKey),
      endDrawer: ResponsiveHelper.isDesktop(context)
          ? const MenuDrawer()
          : null,
      body: ResponsiveHelper.isDesktop(context)
          ? WebHomeScreen(
              scrollController: scrollController,
              availableServiceCount: availableServiceCount,
              signInShakeKey: signInShakeKey,
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  debugPrint('RefreshIndicator triggered');
                  if (availableServiceCount > 0) {
                    await Get.find<ServiceController>().getAllServiceList(
                      1,
                      true,
                    );
                    await Get.find<BannerController>().getBannerList(true);
                    await Get.find<AdvertisementController>()
                        .getAdvertisementList(true);
                    await Get.find<CategoryController>().getCategoryList(true);
                    await Get.find<ServiceController>()
                        .getRecommendedServiceList(1, true);
                    await Get.find<ProviderBookingController>().getProviderList(
                      1,
                      true,
                    );
                    await Get.find<ServiceController>().getPopularServiceList(
                      1,
                      true,
                    );
                    await Get.find<ServiceController>()
                        .getRecentlyViewedServiceList(1, true);
                    await Get.find<ServiceController>().getTrendingServiceList(
                      1,
                      true,
                    );
                    await Get.find<CampaignController>().getCampaignList(true);
                    await Get.find<ServiceController>().getFeatherCategoryList(
                      true,
                    );
                    await Get.find<CartController>().getCartListFromServer();
                  } else {
                    await Get.find<BannerController>().getBannerList(true);
                  }
                },
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: GetBuilder<SplashController>(
                    builder: (splashController) {
                      return GetBuilder<ProviderBookingController>(
                        builder: (providerController) {
                          return GetBuilder<ServiceController>(
                            builder: (serviceController) {
                              bool isAvailableProvider =
                                  providerController.providerList != null &&
                                  providerController.providerList!.isNotEmpty;
                              int? providerBooking = splashController
                                  .configModel
                                  .content
                                  ?.directProviderBooking;
                              bool isLtr =
                                  Get.find<LocalizationController>().isLtr;

                              return CustomScrollView(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: ClampingScrollPhysics(),
                                ),
                                slivers: [
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),
                                  ),
                                  // const HomeSearchWidget(),
                                  SliverToBoxAdapter(
                                    child: Center(
                                      child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: Column(
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 16 / 6,
                                              child: const BannerView(),
                                            ),
                                            availableServiceCount > 0
                                                ? Column(
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeDefault,
                                                        ),
                                                        child: CategoryView(),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeDefault,
                                                        ),
                                                        child:
                                                            HighlightProviderWidget(),
                                                      ),
                                                      // const SizedBox(height: Dimensions.paddingSizeLarge),
                                                      // HorizontalScrollServiceView(
                                                      //   fromPage: 'popular_services',
                                                      //   serviceList: serviceController.popularServiceList,
                                                      // ),
                                                      const RandomCampaignView(),
                                                      const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeLarge,
                                                      ),
                                                      //RecommendedServiceView(height: isLtr ? 210 : 225),
                                                      SizedBox(
                                                        height:
                                                            (providerBooking ==
                                                                    1 &&
                                                                (isAvailableProvider ||
                                                                    providerController
                                                                            .providerList ==
                                                                        null))
                                                            ? Dimensions
                                                                  .paddingSizeLarge
                                                            : 0,
                                                      ),
                                                      // (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null))
                                                      //? NearbyProviderListview(height: isLtr ? 190 : 205)
                                                      // : const SizedBox(),
                                                      (providerBooking == 1 &&
                                                              (isAvailableProvider ||
                                                                  providerController
                                                                          .providerList ==
                                                                      null))
                                                          ? Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeDefault,
                                                                vertical: Dimensions
                                                                    .paddingSizeLarge,
                                                              ),
                                                              child: SizedBox(
                                                                height: 160,
                                                                child: ExploreProviderCard(
                                                                  showShimmer:
                                                                      providerController
                                                                          .providerList ==
                                                                      null,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      if (Get.find<
                                                                SplashController
                                                              >()
                                                              .configModel
                                                              .content
                                                              ?.directProviderBooking ==
                                                          1)
                                                        //const HomeRecommendProvider(height: 220),
                                                        if (Get.find<
                                                                  SplashController
                                                                >()
                                                                .configModel
                                                                .content
                                                                ?.biddingStatus ==
                                                            1)
                                                          (serviceController
                                                                          .allService !=
                                                                      null &&
                                                                  serviceController
                                                                      .allService!
                                                                      .isNotEmpty)
                                                              ? const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .paddingSizeDefault,
                                                                    vertical:
                                                                        Dimensions
                                                                            .paddingSizeLarge,
                                                                  ),
                                                                  child: HomeCreatePostView(
                                                                    showShimmer:
                                                                        false,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                      // if (Get.find<AuthController>().isLoggedIn())
                                                      //   HorizontalScrollServiceView(
                                                      //     fromPage: 'recently_view_services',
                                                      //     serviceList: serviceController.recentlyViewServiceList,
                                                      //   ),
                                                      // const CampaignView(),
                                                      // HorizontalScrollServiceView(
                                                      //   fromPage: 'trending_services',
                                                      //   serviceList: serviceController.trendingServiceList,
                                                      // ),
                                                      // const FeatheredCategoryView(),
                                                      // //(serviceController.allService != null && serviceController.allService!.isNotEmpty)
                                                      //     //? (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context))
                                                      //     ? Padding(
                                                      //   padding: const EdgeInsets.fromLTRB(
                                                      //     Dimensions.paddingSizeDefault,
                                                      //     15,
                                                      //     Dimensions.paddingSizeDefault,
                                                      //     Dimensions.paddingSizeSmall,
                                                      //   ),
                                                      //   // child: TitleWidget(
                                                      //   //   textDecoration: TextDecoration.underline,
                                                      //   //   title: 'all_service'.tr,
                                                      //   //   onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute()),
                                                      //   // ),
                                                      // )
                                                      // : const SizedBox.shrink()
                                                      // : const SizedBox.shrink(),
                                                      // PaginatedListView(
                                                      //   scrollController: scrollController,
                                                      //   totalSize: serviceController.serviceContent?.total,
                                                      //   offset: serviceController.serviceContent?.currentPage,
                                                      //   onPaginate: (int offset) async => await serviceController.getAllServiceList(offset, false),
                                                      //   showBottomSheet: true,
                                                      //   itemView: ServiceViewVertical(
                                                      //     service: serviceController.serviceContent != null ? serviceController.allService : null,
                                                      //     padding: EdgeInsets.symmetric(
                                                      //       horizontal: ResponsiveHelper.isDesktop(context)
                                                      //           ? Dimensions.paddingSizeExtraSmall
                                                      //           : Dimensions.paddingSizeDefault,
                                                      //       vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                                                      //     ),
                                                      //     type: 'others',
                                                      //     noDataType: NoDataType.home,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        .6,
                                                    child:
                                                        const ServiceNotAvailableScreen(),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
