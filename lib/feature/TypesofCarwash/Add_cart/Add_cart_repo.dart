import 'dart:developer';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';

class AddCartRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AddCartRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> addToCart(CartModelBody cartModel) async {
    Response response = await apiClient.postData(AppConstants.addToCart, cartModel.toJson());

    log(" Add to cart responsettttttttttttttttttttt : ${response.body}");
    return response;


  }

}