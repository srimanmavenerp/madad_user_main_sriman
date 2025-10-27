import 'package:madaduser/utils/core_export.dart';

class AppConstants {


  static const String appName = 'Madad';
  static const String appVersion = '3.2'; /// Flutter SDK : 3.29.3
  static const String baseUrl = 'https://madadservices.com';
  static const bool avoidMaintenanceMode = false;
  static const LocalCachesTypeEnum cachesType = LocalCachesTypeEnum.all;
  static const String categoryUrl = '/api/v1/customer/category?limit=20';
  static const String vehiclesEndpoint = '/api/v1/customer/service/vehicles';

  static const String webLandingContents = '/api/v1/customer/landing/contents';
  static const String bannerUri = '/api/v1/customer/banner?limit=10&offset=1';
  static const String bonusUri = '/api/v1/customer/bonus-list?limit=100&offset=1';
  static const String allServiceUri = '/api/v1/customer/service';
  static const String popularServiceUri = '/api/v1/customer/service/popular';
  static const String trendingServiceUri = '/api/v1/customer/service/trending';
  static const String recentlyViewedServiceUri = '/api/v1/customer/service/recently-viewed';
  static const String recommendedServiceUri = '/api/v1/customer/service/recommended';
  static const String recommendedSearchUri = '/api/v1/customer/service/search/recommended';
  static const String offerListUri = '/api/v1/customer/service/offers';
  static const String serviceBasedOnSubcategory = '/api/v1/customer/service/sub-category/';
  static const String itemsBasedOnCampaignId = '/api/v1/customer/campaign/data/items?campaign_id=';
  static const String serviceDetailsUri = '/api/v1/customer/service/detail';
  static const String getServiceReviewList = '/api/v1/customer/service/review/';
  static const String subcategoryUri = '/api/v1/customer/category/childes?limit=20&offset=1&id=';
  static const String categoryServiceUri = '/api/v1/categories/service/';
  static const String configUri = '/api/v1/customer/config';
  static const String customerRemove = '/api/v1/customer/remove-account';
  static const String registerUri = '/api/v1/customer/auth/registration';
  static const String loginUri = '/api/v1/customer/auth/login';
  static const String loginOut = '/api/v1/customer/auth/logout';
  static const String addToCart = '/api/v1/customer/cart/add';
  static const String getCartList = '/api/v1/customer/cart/list?limit=100&offset=1';
  static const String removeCartItem = '/api/v1/customer/cart/remove/';
  static const String removeAllCartItem = '/api/v1/customer/cart/data/empty';
  static const String updateCartQuantity = '/api/v1/customer/cart/update-quantity/';
  static const String updateCartProvider = '/api/v1/customer/cart/update/provider';
  static const String tokenUri = '/api/v1/customer/update/fcm-token';
  static const String bookingList = '/api/v1/customer/booking';
  static const String bookingDetails = '/api/v1/customer/booking';
  static const String subBookingDetails = '/api/v1/customer/booking/single';
  static const String repeatBookingDetails = '/api/v1/customer/booking/repeat';
  static const String trackBooking = '/api/v1/customer/booking/track';
  static const String bookingCancel = '/api/v1/customer/booking/status-update';
  static const String subBookingCancel = '/api/v1/customer/booking/single-repeat-cancel';
  static const String serviceReview = '/api/v1/customer/review/submit';
  static const String bookingReviewList = '/api/v1/customer/review';
  static const String otherInfo = '/api/v1/customer/cart/other-info';
  static const String placeRequest = '/api/v1/customer/booking/request/send';
  static const String addressUri = '/api/v1/customer/address';
  static const String zoneUri = '/api/v1/customer/config/get-zone-id';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String couponUri = '/api/v1/customer/coupon?limit=100&offset=1';
  static const String applyCoupon = '/api/v1/customer/coupon/apply';
  static const String removeCoupon = '/api/v1/customer/coupon/remove';
  static const String orderCancelUri = '/api/v1/customer/order/cancel';
  static const String codSwitchUri = '/api/v1/customer/order/payment-method';
  static const String orderDetailsUri = '/api/v1/customer/order/details?order_id=';
  static const String notificationUri = '/api/v1/customer/notification';
  static const String updateProfileUri = '/api/v1/customer/update/profile';
  static const String searchUri = '/api/v1/customer/service/search';
  static const String searchSuggestion = '/api/v1/customer/service/search-suggestion';
  static const String suggestedSearchUri = '/api/v1/customer/recently-searched-keywords';
  static const String removeSuggestedServiceUri = '/api/v1/customer/remove-searched-keywords';
  static const String campaignUri = '/api/v1/customer/campaign?limit=10&offset=1';
  static const String searchLocationUri = '/api/v1/customer/config/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/customer/config/place-api-details';
  static const String geocodeUri = '/api/v1/customer/config/geocode-api';
  static const String socialLoginUri = '/api/v1/customer/auth/social-login';
  static const String updateZoneUri = '/api/v1/customer/update-zone';
  static const String createChannel = '/api/v1/customer/chat/create-channel';
  static const String getChannelListUrl = '/api/v1/customer/chat/channel-list';
  static const String searchChannelListUrl = '/api/v1/customer/chat/channel-list-search';
  static const String getConversation = '/api/v1/customer/chat/conversation';
  static const String sendMessage = '/api/v1/customer/chat/send-message';
  static const String pages = '/api/v1/customer/config/pages';
  static const String submitNewServiceRequest = '/api/v1/customer/service/request/make';
  static const String getSuggestedServiceList = '/api/v1/customer/service/request/list';
  static const String convertLoyaltyPointUri = '/api/v1/customer/loyalty-point/wallet-transfer';
  static const String loyaltyPointTransactionData = '/api/v1/customer/loyalty-point-transaction';
  static const String walletTransactionData = '/api/v1/customer/wallet-transaction';
  static const String getProviderList = '/api/v1/customer/provider/list';
  static const String getProviderDetails = '/api/v1/customer/provider-details';
  static const String getProviderBasedOnSubcategory = '/api/v1/customer/provider/list-by-sub-category';
  static const String getFeaturedCategoryService = '/api/v1/customer/featured-categories?limit=100&offset=1';

  static const String createCustomizedPost = '/api/v1/customer/post';
  static const String getMyPostList = '/api/v1/customer/post';
  static const String getInterestedProviderList = '/api/v1/customer/post/bid';
  static const String updatePostStatus = '/api/v1/customer/post/bid/update-status';
  static const String getPostDetails = '/api/v1/customer/post/details';
  static const String updatePostInfo = '/api/v1/customer/post/update-info';
  static const String getProviderBidDetails = '/api/v1/customer/post/bid/details';

  static const String sendOtpForVerification = '/api/v1/user/verification/send-otp';
  static const String sendOtpForForgetPassword = '/api/v1/user/forget-password/send-otp';
  static const String verifyOtpForForgetPasswordScreen = '/api/v1/user/forget-password/verify-otp';
  static const String verifyOtpForVerificationScreen = '/api/v1/user/verification/verify-otp';
  static const String phoneOtpVerification= '/api/v1/user/verification/login-otp-verify';
  static const String firebaseOtpVerify = '/api/v1/user/verification/firebase-auth-verify';
  static const String registerWithOtp = '/api/v1/user/verification/registration-with-otp';
  static const String resetPasswordUri = '/api/v1/user/forget-password/reset';

  static const String offlinePaymentUri = '/api/v1/customer/offline-payment/methods?limit=100&offset=1';
  static const String getZoneListApi = '/api/v1/customer/service/area-availability?offset=1&limit=200';
  static const String rebookApi = '/api/v1/customer/rebook/cart-add';
  static const String rebookAvailabilityApi = '/api/v1/customer/rebooking-information?limit=100&offset=1';
  static const String changeLanguage = '/api/v1/customer/change-language';

  static const String getFavoriteServiceList = '/api/v1/customer/favorite/service-list';
  static const String removeFavoriteService = "/api/v1/customer/favorite/service-delete";
  static const String updateFavoriteServiceStatus = "/api/v1/customer/favorite/service";
  static const String getFavoriteProviderList = '/api/v1/customer/favorite/provider-list';
  static const String removeFavoriteProvider = "/api/v1/customer/favorite/provider-destroy";
  static const String updateFavoriteProviderStatus = "/api/v1/customer/favorite/provider";

  static const String advertisementList = '/api/v1/customer/advertisements/ads-list?limit=50&offset=1';
  static const String registerWithSocialMedia = '/api/v1/customer/auth/registration-with-social-media';
  static const String existingAccountCheck = '/api/v1/customer/auth/existing-account-check';
  static const String regularBookingInvoiceUrl = '/admin/booking/customer-invoice/';
  static const String repeatBookingInvoiceUrl = '/admin/booking/customer-fullbooking-invoice/';
  static const String singleRepeatBookingInvoiceUrl = '/admin/booking/customer-fullbooking-single-invoice/';
  static const String addError404Url = '/api/v1/customer/error-link';
  static const String checkExistingUser = '/api/v1/user/check-existing-customer';
  static const String offlinePaymentDataStore = '/api/v1/customer/booking/store-offline-payment-data';
  static const String switchPaymentMethod = '/api/v1/customer/booking/switch-payment-method';
  static const String digitalPaymentResponse = '/api/v1/digital-payment-booking-response';
  static const String newsLetterSubscription = '/api/v1/customer/subscribe-newsletter';
  static const String typesofCarwash ="/api/v1/customer/service/servicesbycategory/afd8745c-2b36-4237-a6c5-65666ff982b0";
  //static const String getCarWashSubscriptionType = 'api/v1/customer/service/get-variant-by-service?service_id=$serviceId&vehicle_type=$vehicleTypeId';
  static String getVariantByServiceUrl(String serviceId, String vehicleTypeId) {
    return '/api/v1/customer/service/get-variant-by-service?service_id=$serviceId&vehicle_type=$vehicleTypeId';

  }

  static String getServicesByCategoryUrl(String categoryId) {
    return '/api/v1/customer/service/servicesbycategory/$categoryId';
  }

 static String getServiceByIdUrl(String serviceId) {
  return '/api/v1/customer/service/details/$serviceId';
  }

  static String getAutoCareVariantByServiceUrl(String serviceId, String zoneId) {
    return '/api/v1/customer/service/get-autocarevariant-by-service?service_id=$serviceId&zone_id=$zoneId';
  }

  /// Shared Key
  static const String theme = 'demand_theme';
  static const String token = 'demand_token';
  static const String guestId = 'guest_id';
  static const String countryCode = 'demand_country_code';
  static const String languageCode = 'demand_language_code';
  static const String acceptCookies = 'demand_accept_cookies';
  static const String userPassword = 'demand_user_password';
  static const String userAddress = 'demand_user_address';
  static const String userNumber = 'demand_user_number';
  static const String userCountryCode = 'demand_user_country_code';
  static const String notification = 'demand_notification';
  static const String searchHistory = 'demand_search_history';
  static const String notificationCount = 'demand_notification_count';
  static const String initialLanguage = 'initial-language';
  static const String onboardingScreen = 'onboarding_screen';
  static const String cookiesManagement = 'cookies_management';
  static const String topic = 'customer';
  static const String zoneId = 'zoneId';
  static const String localizationKey = 'X-localization';
  static const String walletAccessToken = 'wallet_access_token';
  static const String isContinueZone = 'isContinue';
  static const String referredBottomSheet = 'referred_bottom_sheet';
  static const String lastIncompleteOfflineBookingId = 'last_incomplete_offline_booking_id';
 // static const String vehiclesEndpoint = '/api/v1/customer/service/vehicles';


  static Map<String, String> configHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
    AppConstants.zoneId : 'configuration',
  };

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.us, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.ar, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.bn, languageName: 'বাংলা', countryCode: 'BD', languageCode: 'bn'),
    LanguageModel(imageUrl: Images.india, languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
  ];


  static const double limitOfPickedImageSizeInMB = 2;
  static const int limitOfPickedIdentityImageNumber = 2;
  static const double balanceInputLength = 10;

  static const double maxLimitOfFileSentINConversation = 25;
  static const double maxLimitOfTotalFileSent = 5;
  static const double maxSizeOfASingleFile = 10;

  static final List<Map<String, String>> walletTransactionSortingList = [
    {
      'title' : 'all_transactions',
      'value' : ''
    },
    {
      'title' : 'booking_transaction',
      'value' : 'wallet_payment'
    },
    {
      'title' : 'converted_from_loyalty_point',
      'value' : 'loyalty_point_earning'
    },
    {
      'title' : 'added_via_payment_method',
      'value' : 'add_fund'
    },
    {
      'title' : 'earned_by_referral',
      'value' : 'referral_earning'
    },
    {
      'title' : 'admin_fund',
      'value' : 'fund_by_admin'
    },
    {
      'title' : 'refund',
      'value' : 'booking_refund'
    },
  ];


}
