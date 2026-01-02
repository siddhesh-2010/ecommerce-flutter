import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/dio_api.dart';
import '../services/store.dart';

class RegistrationController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString errorMessage = "".obs;
  final RxBool isLoading = false.obs;

  Future<void> register() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    String user ="https://cdn-icons-png.flaticon.com/512/1246/1246351.png";

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = "Please fill everything!";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    final dio = DioService().dio;

    try {
      final response = await dio.post(
        '/users/',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'avatar': user
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final id = data["id"];
        // Store.storeUserData("id", id);

        if (id != null) {
          Get.offNamed('/login');
        } else {
          errorMessage.value = "Registration failed!";
        }
      } else {
        errorMessage.value = "Registration failed! Please try again.";
      }
    } catch (e) {
      errorMessage.value = "Registration error!";
    } finally {
      isLoading.value = false;
    }
  }
}
