import 'package:flutter/material.dart';
import '../routes/routes.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/logout_controller.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final ProductHomeController controller = Get.put(ProductHomeController());

  @override
  void initState() {
    super.initState();
    controller.getProducts();
  }
  // Future<void> fetchProducts() async {
  //   try {
  //     final productList = await controller.getProducts();
  //     setState(() {
  //       products = productList;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to load products: ${e.toString()}';
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Get.find<LogoutController>().logout();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.cart);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(onPressed: (){
            Get.toNamed(Routes.profile);
          }, icon: const Icon(Icons.person))
        ],
      ),
        body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: controller.searchProducts,
                  decoration: const InputDecoration(
                    hintText: 'Search Products',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.product, arguments: product);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              product.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Rs.${product.price}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),

    );
  }
}
