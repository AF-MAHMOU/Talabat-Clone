import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:talabatpro/models/cart_model.dart';

import '../../models/mart_item_model.dart';
import '../../services/cart_service.dart';

class MartScreen extends StatelessWidget {
  const MartScreen({super.key});

  Future<Map<String, List<MartItem>>> _fetchMartItems() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('martItems').get();
    final items =
        snapshot.docs.map((doc) => MartItem.fromMap(doc.data())).toList();

    final Map<String, List<MartItem>> categorized = {};
    for (var item in items) {
      categorized.putIfAbsent(item.category, () => []).add(item);
    }

    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talabat Mart'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<Map<String, List<MartItem>>>(
        future: _fetchMartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items available'));
          }

          final categories = snapshot.data!;

          return ListView(
            children:
                categories.entries.map((entry) {
                  final category = entry.key;
                  final items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildMartCard(context, item);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildMartCard(BuildContext context, MartItem item) {
    final cartService = Provider.of<CartService>(context, listen: false);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EGP ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          cartService.addItem(
                            CartItem(
                              id:
                                  'mart_${item.category}_${item.name}_${item.price}', // 👈 unique ID here
                              name: item.name,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              source: ItemSourceType.mart,
                            ),
                            null,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item added to cart')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              action: SnackBarAction(
                                label: 'Clear Cart',
                                onPressed: () {
                                  cartService.clearCart();
                                  cartService.addItem(
                                    CartItem(
                                      id: item.id,
                                      name: item.name,
                                      price: item.price,
                                      imageUrl: item.imageUrl,
                                      source: ItemSourceType.mart,
                                    ),
                                    null,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
