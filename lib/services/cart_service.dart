import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartService extends ChangeNotifier {
  Cart _cart = Cart(items: [], restaurantId: null);

  Cart get cart => _cart;

 void addItem(CartItem item, String? restaurantId) {
  // If cart is empty, initialize it
  if (_cart.items.isEmpty) {
    _cart = Cart(items: [], restaurantId: restaurantId);
  }

  // Prevent mixing mart and restaurant items
  if (_cart.items.isNotEmpty && _cart.items.first.source != item.source) {
    throw Exception('Cannot mix mart and restaurant items. Please clear your cart first.');
  }

  // Only check restaurantId if item is from a restaurant
  if (item.source == ItemSourceType.restaurant && _cart.restaurantId != restaurantId) {
    throw Exception('Cannot add items from different restaurants. Please clear your cart first.');
  }

  // Add or increment item
  final index = _cart.items.indexWhere((i) => i.id == item.id);
  if (index >= 0) {
    _cart.items[index].quantity++;
  } else {
    _cart.items.add(item);
  }

  notifyListeners();
}



  void removeItem(String itemId) {
    _cart.items.removeWhere((item) => item.id == itemId);
    if (_cart.items.isEmpty) {
      _cart = Cart(items: [], restaurantId: null);
    }
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    final index = _cart.items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _cart.items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(CartItem item) {
    final index = _cart.items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      if (_cart.items[index].quantity > 1) {
        _cart.items[index].quantity--;
      } else {
        _cart.items.removeAt(index);
        if (_cart.items.isEmpty) {
          _cart = Cart(items: [], restaurantId: null);
        }
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart = Cart(items: [], restaurantId: null);
    notifyListeners();
  }
} 