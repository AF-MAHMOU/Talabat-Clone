import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String restaurant;
  final List<String> items;
  final double price;
  final DateTime createdAt;
  final int? rating;

  OrderModel({
    required this.id,
    required this.userId,
    required this.restaurant,
    required this.items,
    required this.price,
    required this.createdAt,
    this.rating,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      restaurant: map['restaurant'],
      items: List<String>.from(map['items']),
      price: (map['price'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'restaurant': restaurant,
      'items': items,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      if (rating != null) 'rating': rating,
    };
  }
}
