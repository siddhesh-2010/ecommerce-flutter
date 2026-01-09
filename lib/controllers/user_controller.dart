import 'package:demo_login/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/dio_api.dart';
import '../services/store.dart';

class UserController extends GetxController {
  final RxString errorMessage = "".obs;
  final RxBool isLoading = false.obs;
  // final id = Get.find<ProfileController>().idController.text;

  final ProfileController controller = Get.find<ProfileController>();

  Future<void> deleteUser(String id) async {
    isLoading.value = true;
    errorMessage.value = "";

    final dio = DioService().dio;
    final token = await Store.getToken();

    if (token == null) {
      errorMessage.value = "User not logged in";
      isLoading.value = false;
      return;
    }

    try {
      final response = await dio.delete(
        '/users/$id',
      );

      if (response.statusCode == 200) {
        await Store.removeToken();
        Get.offNamed(Routes.register);
      } else {
        errorMessage.value = "Failed to delete user";
      }
    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String id) async {
    isLoading.value = true;
    errorMessage.value = "";

    final dio = DioService().dio;
    final token = await Store.getToken();

    if (token == null) {
      errorMessage.value = "User not logged in";
      isLoading.value = false;
      return;
    }

    try {
      final response = await dio.put(
        '/users/$id',
        data: {
          'name': controller.nameController.text,
          'email': controller.emailController.text,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User updated successfully');
      } else {
        errorMessage.value = "Failed to update user";
      }
    } catch (e) {
      errorMessage.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }
}