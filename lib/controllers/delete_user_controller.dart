import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/dio_api.dart';
import '../services/store.dart';

class DeleteUserController extends GetxController {
  final RxString errorMessage = "".obs;
  final RxBool isLoading = false.obs;
  // final id = Get.find<ProfileController>().idController.text;

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
}