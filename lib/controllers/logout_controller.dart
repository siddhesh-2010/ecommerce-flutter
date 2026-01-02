import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/dio_api.dart';
import '../services/store.dart';
import '../routes/routes.dart';
import 'cart_controller.dart';

class LogoutController extends GetxController {
  Future<void> logout() async {
    try {
      // if (Get.isRegistered<CartController>()) {
      //   Get.find<CartController>().clearCart();
      // }

      // await Store.clear(); 
      await Store.removeToken();
      DioService().dio.options.headers.remove('Authorization');

      Get.offAllNamed(Routes.login);
    } catch (e) {
      debugPrint('$e');
    }
  }
}
