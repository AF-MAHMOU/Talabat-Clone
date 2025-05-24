import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/restaurant_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

Future<List<Restaurant>> getAllRestaurants() async {
  final query = await _db.collection('restaurants').get();
  return query.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
}

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final query = await _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return query.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> createOrder(OrderModel order) async {
    await _db.collection('orders').add(order.toMap());
  }
}
