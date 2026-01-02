import '../models/products.dart';
import 'package:get/get.dart';

class CartItem {
  final Product product;
  RxInt quantity;

  CartItem({
    required this.product,
    int quantity = 1,
  }) : quantity = quantity.obs;

  double get totalPrice {
    return product.price * quantity.value;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity.value,
    };
  }
}
