import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:talabatpro/models/mart_item_model.dart';
import 'package:talabatpro/screens/talabatmart/mart.dart';
import 'dart:math' as math;
import '../../models/restaurant_model.dart';
import '../../services/restaurant_service.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final RestaurantService _restaurantService = RestaurantService();
  String? _selectedCategory;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Home
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1: // Cart
        Navigator.pushNamed(context, '/cart');
        break;
      case 2: // Account
        Navigator.pushNamed(context, '/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.deepOrange,
              toolbarHeight: 120,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top row with address and cart
                  Row(
                    children: [
                      // Address Section
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final addresses =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(authService.currentUser?.uid)
                                    .collection('addresses')
                                    .get();

                            if (!mounted) return;

                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => Container(
                                    padding: const EdgeInsets.all(19),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Select Delivery Address',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ...addresses.docs.map((doc) {
                                          final address = doc.data();
                                          return ListTile(
                                            title: Text(address['name']),
                                            subtitle: Text(
                                              '${address['street']}, ${address['building']}',
                                            ),
                                            trailing:
                                                address['isDefault'] == true
                                                    ? const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                    : null,
                                            onTap: () async {
                                              // Update all addresses to not be default
                                              for (var addr in addresses.docs) {
                                                await addr.reference.update({
                                                  'isDefault': false,
                                                });
                                              }
                                              // Set selected address as default
                                              await doc.reference.update({
                                                'isDefault': true,
                                              });
                                              if (!mounted) return;
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                              context,
                                              '/add-address',
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepOrange,
                                            minimumSize: const Size(
                                              double.infinity,
                                              50,
                                            ),
                                          ),
                                          child: const Text('Add New Address'),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Deliver to',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white70,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(authService.currentUser?.uid)
                                        .collection('addresses')
                                        .where('isDefault', isEqualTo: true)
                                        .limit(1)
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      'Select delivery address',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                  final address =
                                      snapshot.data!.docs.first.data()
                                          as Map<String, dynamic>;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          address['name'] ??
                                              'Select delivery address',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Cart Icon
                      Consumer<CartService>(
                        builder: (context, cartService, child) {
                          final itemCount = cartService.cart.items.length;
                          if (itemCount == 0) return const SizedBox.shrink();

                          return Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    itemCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // Admin Button
                      FutureBuilder<bool>(
                        future: authService.isUserAdmin(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return IconButton(
                              icon: const Icon(Icons.admin_panel_settings),
                              onPressed: () {
                                Navigator.pushNamed(context, '/admin');
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(double.infinity, 10),
                painter: WavePainter(),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Talabat Mart Section
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Talabat Mart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MartScreen(),
                            ),
                          ); // navigate to MartScreen
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Firestore fetching
                  SizedBox(
                    height: 180,
                    child: FutureBuilder<QuerySnapshot>(
                      future:
                          FirebaseFirestore.instance
                              .collection('martItems')
                              .limit(10)
                              .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No items available'),
                          );
                        }

                        final items =
                            snapshot.data!.docs
                                .map(
                                  (doc) => MartItem.fromMap(
                                    doc.data() as Map<String, dynamic>,
                                  ),
                                )
                                .toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildMartItem(
                              item.name,
                              item.imageUrl,
                              'EGP ${item.price}',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Promotions Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepOrange),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer,
                    color: Colors.deepOrange,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Check out available promotions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.pushNamed(context, '/promotions');
                    },
                  ),
                ],
              ),
            ),

            // Active Order Banner
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('orders')
                      .where('userId', isEqualTo: authService.currentUser?.uid)
                      .where('status', whereIn: ['preparing', 'delivering'])
                      .orderBy('status')
                      .orderBy('createdAt', descending: true)
                      .limit(1)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Show most recent order if no active orders
                  return StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('orders')
                            .where(
                              'userId',
                              isEqualTo: authService.currentUser?.uid,
                            )
                            .orderBy('createdAt', descending: true)
                            .limit(1)
                            .snapshots(),
                    builder: (context, recentSnapshot) {
                      if (!recentSnapshot.hasData ||
                          recentSnapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final order = recentSnapshot.data!.docs.first;
                      final data = order.data() as Map<String, dynamic>;
                      final restaurantId = data['restaurantId'] as String?;

                      return StreamBuilder<DocumentSnapshot>(
                        stream:
                            restaurantId != null
                                ? FirebaseFirestore.instance
                                    .collection('restaurants')
                                    .doc(restaurantId)
                                    .snapshots()
                                : null,
                        builder: (context, restaurantSnapshot) {
                          final restaurantName =
                              restaurantSnapshot.data?.get('name') as String? ??
                              'Restaurant';

                          return Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurantName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Your last order'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/restaurant-details',
                                      arguments: restaurantId,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                  ),
                                  child: const Text('Order Again'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                final order = snapshot.data!.docs.first;
                final data = order.data() as Map<String, dynamic>;
                final status = data['status'] as String;
                final total = data['total'] as double;
                final restaurantId = data['restaurantId'] as String?;

                return StreamBuilder<DocumentSnapshot>(
                  stream:
                      restaurantId != null
                          ? FirebaseFirestore.instance
                              .collection('restaurants')
                              .doc(restaurantId)
                              .snapshots()
                          : null,
                  builder: (context, restaurantSnapshot) {
                    final restaurantName =
                        restaurantSnapshot.data?.get('name') as String? ??
                        'Restaurant';

                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepOrange),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_shipping,
                                color: Colors.deepOrange,
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status == 'preparing'
                                          ? 'Order is being prepared'
                                          : 'Order is on the way',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total: EGP ${total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/order-details',
                                    arguments: order.id,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard('All', Icons.restaurant, null),
                        _buildCategoryCard(
                          'Burgers',
                          Icons.lunch_dining,
                          'Burgers',
                        ),
                        _buildCategoryCard('Pizza', Icons.local_pizza, 'Pizza'),
                        _buildCategoryCard('Sushi', Icons.set_meal, 'Sushi'),
                        _buildCategoryCard(
                          'Desserts',
                          Icons.icecream,
                          'Desserts',
                        ),
                        _buildCategoryCard(
                          'Drinks',
                          Icons.local_drink,
                          'Drinks',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Restaurants
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Restaurants',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<Restaurant>>(
                    stream:
                        _selectedCategory == null
                            ? _restaurantService.getTrendingRestaurants()
                            : _restaurantService.getRestaurantsByCategory(
                              _selectedCategory!,
                            ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final restaurants = snapshot.data ?? [];

                      if (restaurants.isEmpty) {
                        return const Center(
                          child: Text('No restaurants available'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  restaurant.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                restaurant.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.rating.toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${restaurant.cuisine} • ${restaurant.deliveryTime} min',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/restaurant-details',
                                  arguments: restaurant,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildMartItem(String title, String imageUrl, String price) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCategoryCard(String title, IconData icon, String? category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          color: isSelected ? Colors.deepOrange : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : Colors.deepOrange,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.8 +
            math.sin((i / size.width * 2 * math.pi) + (math.pi / 2)) * 4,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
