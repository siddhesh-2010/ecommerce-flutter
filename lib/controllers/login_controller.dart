import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/dio_api.dart';
import '../services/store.dart';
import '../controllers/cart_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString errormessage = "".obs;
  final RxBool isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      errormessage.value = "Please enter email & password";
      return;
    }

    isLoading.value = true;
    errormessage.value = "";

    final dio = DioService().dio;

    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final accessToken = data["access_token"];
        await Store.setToken(accessToken);

        if (accessToken != null) {
          Get.offNamed(Routes.home);
          final profileResponse = await dio.get('/auth/profile');
          if (profileResponse.statusCode == 200) {
            final userId = profileResponse.data['id'];
            if (userId != null) {
              await Store.storeUserId(userId);
            }
          }
          if (Get.isRegistered<CartController>()) {
            Get.find<CartController>().onUserLogin();
          }
        } else {
          errormessage.value = "Invalid credentials";
        }
      } else {
        errormessage.value = "Login failed. Please try again.";
      }
    } catch (e) {
      errormessage.value = "Login error";
    } finally {
      isLoading.value = false;
    }
  }
}
