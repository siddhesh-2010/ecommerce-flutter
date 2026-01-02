import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_screen.dart';
import 'controllers/cart_controller.dart';
import 'controllers/logout_controller.dart';
import 'screens/registration_screen.dart';

void main() {
  Get.put<CartController>(CartController(), permanent: true);
  Get.put<LogoutController>(LogoutController(), permanent: true);
  runApp(const MainApp());
}

class AppRoutes {
  static const initial = Routes.login;
  static final routes = [
    GetPage(name: Routes.login, page: () => const LoginApp()),
    GetPage(name: Routes.home, page: () => const HomeApp()),
    GetPage(name: Routes.product, page: () => const ProductApp()),
    GetPage(name: Routes.cart, page: () => const CartApp()),
    GetPage(name: Routes.profile, page: () => ProfileApp()),
    GetPage(name: Routes.register, page: () => const RegistrationApp()),
  ];
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}
