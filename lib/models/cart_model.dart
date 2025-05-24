enum ItemSourceType { restaurant, mart }

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final ItemSourceType source;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.source,

    this.quantity = 1,
  });

  double get total => price * quantity;
}

class Cart {
  final List<CartItem> items;
  final double deliveryFee;
  final String? restaurantId;

  Cart({required this.items, this.deliveryFee = 5.0, this.restaurantId});

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + deliveryFee;

  Cart copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    String? restaurantId,
  }) {
    return Cart(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }
}
