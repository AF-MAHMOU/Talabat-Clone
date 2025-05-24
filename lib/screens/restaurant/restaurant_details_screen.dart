import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../models/restaurant_model.dart';
import '../../models/cart_model.dart';
import '../../services/cart_service.dart';
import '../../widgets/custom_app_bar.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  Timer? _snackbarTimer;
  String? _lastSnackbarMessage;

  void _showSnackbar(String message) {
    if (_lastSnackbarMessage == message) {
      return; // Skip if same message
    }
    _lastSnackbarMessage = message;

    if (_snackbarTimer?.isActive ?? false) {
      _snackbarTimer?.cancel();
    }

    _snackbarTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _snackbarTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: CustomAppBar(title: restaurant.name, showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Image.network(
              restaurant.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        restaurant.cuisine,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${restaurant.deliveryTime} min • ${restaurant.deliveryFee} EGP delivery',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    restaurant.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Menu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...restaurant.menu?.entries.map((entry) {
                        final item = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['imageUrl'] as String,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['description'] as String,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${item['price']} EGP',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final bool isMart =
                                                  restaurant ==
                                                  null; // or pass a flag if you're in Mart mode

                                              try {
                                                cartService.addItem(
                                                  CartItem(
                                                    id:
                                                        isMart
                                                            ? item['id']
                                                            : '${restaurant.id}_${item['name']}',
                                                    name:
                                                        item['name'] as String,
                                                    price:
                                                        item['price'] as double,
                                                    imageUrl:
                                                        item['imageUrl']
                                                            as String,
                                                    source:
                                                        isMart
                                                            ? ItemSourceType
                                                                .mart
                                                            : ItemSourceType
                                                                .restaurant,
                                                  ),
                                                  isMart
                                                      ? 'MART'
                                                      : restaurant.id,
                                                );
                                                _showSnackbar(
                                                  'Item added to cart',
                                                );
                                              } catch (e) {
                                                _showSnackbar(e.toString());
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.toString()),
                                                    action: SnackBarAction(
                                                      label: 'Clear Cart',
                                                      onPressed: () {
                                                        cartService.clearCart();
                                                        cartService.addItem(
                                                          CartItem(
                                                            id:
                                                                isMart
                                                                    ? item['id']
                                                                    : '${restaurant.id}_${item['name']}',
                                                            name:
                                                                item['name']
                                                                    as String,
                                                            price:
                                                                item['price']
                                                                    as double,
                                                            imageUrl:
                                                                item['imageUrl']
                                                                    as String,
                                                            source:
                                                                isMart
                                                                    ? ItemSourceType
                                                                        .mart
                                                                    : ItemSourceType
                                                                        .restaurant,
                                                          ),
                                                          isMart
                                                              ? 'MART'
                                                              : restaurant.id,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepOrange,
                                            ),
                                            child: const Text('Add to Cart'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
