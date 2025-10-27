import 'package:madaduser/common/models/api_response_model.dart';
import 'package:madaduser/common/repo/data_sync_repo.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class SplashRepo extends DataSyncRepo {


  SplashRepo({required super.apiClient, required SharedPreferences super.sharedPreferences});

  Future<ApiResponseModel<T>> getConfigData<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.configUri, source);
  }

  Future<bool> initSharedData() async {

    if(!sharedPreferences!.containsKey(AppConstants.theme)) {
      sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      sharedPreferences!.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      sharedPreferences!.setString(AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }

    if(!sharedPreferences!.containsKey(AppConstants.searchHistory)) {
      sharedPreferences!.setStringList(AppConstants.searchHistory, []);
    }
    if(!sharedPreferences!.containsKey(AppConstants.notification)) {
      sharedPreferences!.setBool(AppConstants.notification, true);
    }
    if(!sharedPreferences!.containsKey(AppConstants.notificationCount)) {
      sharedPreferences!.setInt(AppConstants.notificationCount, 0);
    }

    if(!sharedPreferences!.containsKey(AppConstants.acceptCookies)) {
      sharedPreferences!.setBool(AppConstants.acceptCookies, false);
    }

    if(!sharedPreferences!.containsKey(AppConstants.guestId)) {
      sharedPreferences!.setString(AppConstants.guestId, "");
    }

    if(!sharedPreferences!.containsKey(AppConstants.referredBottomSheet)){
      sharedPreferences!.setBool(AppConstants.referredBottomSheet, true);
    }

    if (!sharedPreferences!.containsKey(AppConstants.initialLanguage)) {
      sharedPreferences!.setBool(AppConstants.initialLanguage, true);
    }
    if (!sharedPreferences!.containsKey(AppConstants.onboardingScreen)) {
      sharedPreferences!.setBool(AppConstants.onboardingScreen, true);
    }

    return Future.value(true);
  }

  void disableShowOnboardingScreen() {
    sharedPreferences!.setBool(AppConstants.onboardingScreen, false);
  }

  bool isShowOnboardingScreen() {
    return (sharedPreferences!.getBool(AppConstants.onboardingScreen) ?? false);
  }

  void disableShowInitialLanguageScreen() {
    sharedPreferences!.setBool(AppConstants.initialLanguage, false);
  }

  bool isShowInitialLanguageScreen() {
    return (sharedPreferences!.getBool(AppConstants.initialLanguage) ?? false);
  }

  Future<void> setGuestId(String guestId){
    return  sharedPreferences!.setString(AppConstants.guestId, guestId);
  }

  String getGuestId(){
    return  sharedPreferences!.getString(AppConstants.guestId)??"";
  }

  bool getSavedCookiesData() {
    return sharedPreferences!.getBool(AppConstants.acceptCookies)!;
  }

  Future<void> saveCookiesData(bool data) async {
    try {
      await sharedPreferences!.setBool(AppConstants.acceptCookies, data);

    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateLanguage(String id) async {
    Response response = await apiClient.postData(AppConstants.changeLanguage, {
      "guest_id" : id
    });
    return response;
  }

  Future<Response> addError404UrlToServer(String url) async {
    Response response = await apiClient.postData(AppConstants.addError404Url, {
      "url" : url
    });
    return response;
  }

  Future<Response> newsLetterSubscription({required String email}) async {
    Response response = await apiClient.postData(AppConstants.newsLetterSubscription, {
      "email" : email
    });
    return response;
  }

}
