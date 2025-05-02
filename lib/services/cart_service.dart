import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartService extends ChangeNotifier {
  Cart _cart = Cart(items: [], restaurantId: null);

  Cart get cart => _cart;

  void addItem(CartItem item, String restaurantId) {
    // If cart is empty, set the restaurant ID
    if (_cart.items.isEmpty) {
      _cart = Cart(items: [], restaurantId: restaurantId);
    }
    
    // Check if item is from the same restaurant
    if (_cart.restaurantId != restaurantId) {
      throw Exception('Cannot add items from different restaurants. Please clear your cart first.');
    }

    final existingItemIndex = _cart.items.indexWhere((i) => i.id == item.id);
    
    if (existingItemIndex >= 0) {
      _cart.items[existingItemIndex].quantity++;
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