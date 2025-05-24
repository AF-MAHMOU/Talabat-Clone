import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String cuisine;
  final String description;
  final bool isOpen;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final double minimumOrder;
  final List<String> categories;
  final GeoPoint location;
  final Map<String, dynamic>? menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.cuisine,
    required this.description,
    required this.isOpen,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.categories,
    required this.location,
    this.menu,
  });
  

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      cuisine: data['cuisine'] ?? '',
      description: data['description'] ?? '',
      isOpen: data['isOpen'] ?? false,
      deliveryTime: data['deliveryTime'] ?? 0,
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      minimumOrder: (data['minimumOrder'] ?? 0.0).toDouble(),
      categories: List<String>.from(data['categories'] ?? []),
      location: data['location'] ?? const GeoPoint(0, 0),
      menu: data['menu'],
    );

    
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'cuisine': cuisine,
      'description': description,
      'isOpen': isOpen,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'categories': categories,
      'location': location,
      'menu': menu,
    };
  }


}
