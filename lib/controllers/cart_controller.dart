import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/products.dart';
import '../models/cart_item.dart';
import '../services/cart_store.dart';
import '../services/store.dart';

class CartController extends GetxController {
  final RxList<CartItem> cart = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  int? _currentUserId;

  int get totalItems {
    int count = 0;
    for (var i in cart) {
      count += i.quantity.value;
    }
    return count;
  }

  double get totalPrice => cart.fold(0, (sum, item) => sum + item.totalPrice);

  bool get isCartEmpty => cart.isEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndCart();
  }

  Future<void> _loadUserIdAndCart() async {
    _currentUserId = await Store.getUserId();
    if (_currentUserId != null) {
      await loadCartFromStorage();
    }
  }

  Future<void> loadCartFromStorage() async {
    if (_currentUserId == null) return;

    isLoading.value = true;
    try {
      final savedCartItems = await CartStore.getCartItems(_currentUserId!);
      cart.assignAll(savedCartItems);
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveCartToStorage() async {
    if (_currentUserId == null) return;
    await CartStore.storeCartItems(cart.toList(), _currentUserId!);
  }

  void addtoCart(Product product) {
    int existingIndex = cart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      cart[existingIndex].quantity.value++;
    } else {
      cart.add(CartItem(product: product));
    }

    cart.refresh();
    _saveCartToStorage();

    Get.snackbar(
      'SUCCESS!',
      '${product.title} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white,
    );
  }

  void removeFromCart(Product product) {
    cart.removeWhere(
      (item) => item.product.id == product.id,
    );

    if (_currentUserId != null) {
      CartStore.removeCartItem(product.id, _currentUserId!);
    }
  }

  void increaseQuantity(Product product) {
    int existingIndex = cart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      cart[existingIndex].quantity.value++;

      if (_currentUserId != null) {
        CartStore.updateCartItemQuantity(
            product.id, cart[existingIndex].quantity.value, _currentUserId!);
      }
    }
  }

  void decreaseQuantity(Product product) {
    int existingIndex = cart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      if (cart[existingIndex].quantity.value > 1) {
        cart[existingIndex].quantity.value--;

        if (_currentUserId != null) {
          CartStore.updateCartItemQuantity(
              product.id, cart[existingIndex].quantity.value, _currentUserId!);
        }
      } else {
        removeFromCart(product);
      }
    }
  }

  void clearCart() {
    cart.clear();

    if (_currentUserId != null) {
      CartStore.clearCart(_currentUserId!);
    }
  }

  bool isInCart(Product product) {
    return cart.any((item) => item.product.id == product.id);
  }

  CartItem? getCart(Product product) {
    return cart.firstWhereOrNull((item) => item.product.id == product.id);
  }

  void onUserLogin() async {
    _currentUserId = await Store.getUserId();
    if (_currentUserId != null) {
      loadCartFromStorage();
    }
  }
}
