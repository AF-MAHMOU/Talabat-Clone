import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class RestaurantService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'restaurants';

  // Get trending restaurants (sorted by rating)
  Stream<List<Restaurant>> getTrendingRestaurants() {
    return _db
        .collection(_collection)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    });
  }

  // Get restaurants by category
  Stream<List<Restaurant>> getRestaurantsByCategory(String category) {
    return _db
        .collection(_collection)
        .where('categories', arrayContains: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    });
  }

  // Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Restaurant.fromFirestore(doc);
    }
    return null;
  }

  // Add a new restaurant (admin only)
  Future<void> addRestaurant(Restaurant restaurant) async {
    await _db.collection(_collection).doc(restaurant.id).set(restaurant.toMap());
  }

  // Update restaurant (admin only)
  Future<void> updateRestaurant(Restaurant restaurant) async {
    await _db.collection(_collection).doc(restaurant.id).update(restaurant.toMap());
  }

  // Delete restaurant (admin only)
  Future<void> deleteRestaurant(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
} 