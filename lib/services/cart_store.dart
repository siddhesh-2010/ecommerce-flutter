import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/products.dart';

class CartStore {
  const CartStore._();

  static Future<void> storeCartItems(List<CartItem> items,int userId,) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId.toString();

    await prefs.setStringList(
      key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<List<CartItem>> getCartItems(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$userId';

    final List<String>? jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return [];
    }

    final List<CartItem> cartItems = jsonList.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return CartItem(
        product: Product.fromJson(jsonMap['product']),
        quantity: jsonMap['quantity'],
      );
    }).toList();

    return cartItems;
  }

  static Future<void> clearCart(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$userId';
    await prefs.remove(key);
  }

  static Future<void> removeCartItem(int productId, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$userId';

    final List<String>? jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return;
    }

    final List<String> updatedJsonList = jsonList.where((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final CartItem item = CartItem(
        product: Product.fromJson(jsonMap['product']),
        quantity: jsonMap['quantity'],
      );
      return item.product.id != productId;
    }).toList();

    await prefs.setStringList(key, updatedJsonList);
  }

  static Future<void> updateCartItemQuantity(
      int productId, int quantity, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$userId';

    final List<String>? jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return;
    }

    final List<String> updatedJsonList = jsonList.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final CartItem item = CartItem(
        product: Product.fromJson(jsonMap['product']),
        quantity: jsonMap['quantity'],
      );

      if (item.product.id == productId) {
        item.quantity.value = quantity;
      }

      return jsonEncode(item.toJson());
    }).toList();

    await prefs.setStringList(key, updatedJsonList);
  }
}
