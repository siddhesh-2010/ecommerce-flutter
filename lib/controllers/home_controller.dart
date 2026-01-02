import 'package:get/get.dart';

import '../models/products.dart';
import '../services/dio_api.dart';

class ProductHomeController extends GetxController {
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final isLoading = true.obs;

  Future<void> getProducts() async {
    try {
      final dio = DioService().dio;
      final response = await dio.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final loadedProducts =
            data.map((json) => Product.fromJson(json)).toList();

        products.value = loadedProducts;
        filteredProducts.value = loadedProducts;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load products');
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

