import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/dio_api.dart';
import '../services/store.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/profile_store.dart';

class RegistrationController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString errorMessage = "".obs;
  final RxBool isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

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
        // final name = data["name"];
        // final email = data["email"];
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
      ProfileStore.storeProfileImage(image.path, await Store.getUserId() ?? 0);
    }
  }

  void showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(context).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    selectedImage.value = File(image.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


}
