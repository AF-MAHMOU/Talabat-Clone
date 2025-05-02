import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  static Future<void> seedRestaurants() async {
    final firestore = FirebaseFirestore.instance;
    
    // Clear existing data
    final restaurantsSnapshot = await firestore.collection('restaurants').get();
    for (var doc in restaurantsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Add new restaurants
    final restaurants = [
      {
        'name': 'Burger King',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'rating': 4.5,
        'cuisine': 'Fast Food',
        'description': 'Home of the Whopper. Serving flame-grilled burgers since 1954.',
        'isOpen': true,
        'deliveryTime': 30,
        'deliveryFee': 15.0,
        'minimumOrder': 50.0,
        'categories': ['Burgers', 'Fast Food'],
        'location': const GeoPoint(30.0444, 31.2357), // Cairo coordinates
        'menu': {
          'whopper': {
            'name': 'Whopper',
            'description': '1/4 lb flame-grilled beef patty topped with tomatoes, lettuce, mayonnaise, pickles, and onions.',
            'price': 89.99,
            'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'chicken_royal': {
            'name': 'Chicken Royal',
            'description': 'Crispy chicken fillet topped with fresh lettuce and creamy mayonnaise.',
            'price': 79.99,
            'imageUrl': 'https://images.unsplash.com/photo-1562967914-608f82629710?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'fries': {
            'name': 'French Fries',
            'description': 'Crispy golden fries seasoned with our special blend of spices.',
            'price': 29.99,
            'imageUrl': 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
        },
      },
      {
        'name': 'Pizza Hut',
        'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'rating': 4.3,
        'cuisine': 'Italian',
        'description': 'World\'s largest pizza chain. Making it great since 1958.',
        'isOpen': true,
        'deliveryTime': 45,
        'deliveryFee': 20.0,
        'minimumOrder': 60.0,
        'categories': ['Pizza', 'Italian'],
        'location': const GeoPoint(30.0444, 31.2357), // Cairo coordinates
        'menu': {
          'pepperoni': {
            'name': 'Pepperoni Pizza',
            'description': 'Classic pizza topped with pepperoni and mozzarella cheese.',
            'price': 129.99,
            'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'margherita': {
            'name': 'Margherita Pizza',
            'description': 'Fresh tomatoes, mozzarella, basil, and olive oil.',
            'price': 119.99,
            'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'pasta': {
            'name': 'Spaghetti Bolognese',
            'description': 'Spaghetti with our signature meat sauce and parmesan cheese.',
            'price': 89.99,
            'imageUrl': 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
        },
      },
      {
        'name': 'KFC',
        'imageUrl': 'https://images.unsplash.com/photo-1562967914-608f82629710?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'rating': 4.2,
        'cuisine': 'Fast Food',
        'description': 'Finger lickin\' good. The world\'s most popular chicken restaurant chain.',
        'isOpen': true,
        'deliveryTime': 35,
        'deliveryFee': 15.0,
        'minimumOrder': 50.0,
        'categories': ['Chicken', 'Fast Food'],
        'location': const GeoPoint(30.0444, 31.2357), // Cairo coordinates
        'menu': {
          'bucket': {
            'name': 'Family Bucket',
            'description': '8 pieces of our famous fried chicken with 2 large sides.',
            'price': 199.99,
            'imageUrl': 'https://images.unsplash.com/photo-1562967914-608f82629710?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'zinger': {
            'name': 'Zinger Burger',
            'description': 'Crispy chicken fillet with lettuce and spicy mayo in a sesame bun.',
            'price': 69.99,
            'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          'wings': {
            'name': 'Hot Wings',
            'description': '8 pieces of our famous hot wings with your choice of sauce.',
            'price': 89.99,
            'imageUrl': 'https://images.unsplash.com/photo-1562967914-608f82629710?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
        },
      },
    ];

    // Add restaurants to Firestore
    for (var restaurant in restaurants) {
      await firestore.collection('restaurants').add(restaurant);
    }
  }

  static Future<void> seedPromotions() async {
    final firestore = FirebaseFirestore.instance;
    
    // Clear existing data
    final promotionsSnapshot = await firestore.collection('promotions').get();
    for (var doc in promotionsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Add new promotions
    final promotions = [
      {
        'title': '50% OFF First Order',
        'description': 'Get 50% off on your first order with code: FIRST50',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'validUntil': DateTime.now().add(const Duration(days: 30)),
      },
      {
        'title': 'Free Delivery',
        'description': 'Free delivery on orders above 200 EGP',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
        'validUntil': DateTime.now().add(const Duration(days: 15)),
      },
    ];

    // Add promotions to Firestore
    for (var promotion in promotions) {
      await firestore.collection('promotions').add(promotion);
    }
  }
} 