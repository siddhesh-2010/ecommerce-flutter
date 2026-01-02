import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/dio_api.dart';
import '../services/store.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final RxString errorMessage = "".obs;
  final RxBool isLoading = false.obs;

  Future<void> loadProfile() async {
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
      final response = await dio.get('/auth/profile');

      if (response.statusCode == 200) {
        final data = response.data;
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        avatarController.text = data['avatar'] ?? '';
        idController.text = data['id']?.toString() ?? '';
      } else {
        errorMessage.value = "Failed to load profile";
      }
    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }
}