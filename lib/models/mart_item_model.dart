class MartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool inStock;
  final int quantity;

  MartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.inStock = true,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'inStock': inStock,
      'quantity': quantity,
    };
  }

  factory MartItem.fromMap(Map<String, dynamic> map) {
    return MartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      inStock: map['inStock'] ?? true,
      quantity: map['quantity'] ?? 0,
    );
  }
} 