import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your account'),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Account',
        showUserMenu: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepOrange,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'] ?? 'User',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Account Options
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSection(
                  'Orders',
                  [
                    _buildListTile(
                      'Order History',
                      Icons.history,
                      () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                  ],
                ),
                _buildSection(
                  'Address',
                  [
                    _buildListTile(
                      'Manage Addresses',
                      Icons.location_on,
                      () {
                        Navigator.pushNamed(context, '/addresses');
                      },
                    ),
                  ],
                ),
                _buildSection(
                  'Payment',
                  [
                    _buildListTile(
                      'Payment Methods',
                      Icons.payment,
                      () {
                        Navigator.pushNamed(context, '/payment-methods');
                      },
                    ),
                  ],
                ),
                _buildSection(
                  'Support',
                  [
                    _buildListTile(
                      'Help Center',
                      Icons.help_outline,
                      () {
                        Navigator.pushNamed(context, '/help-center');
                      },
                    ),
                    _buildListTile(
                      'About',
                      Icons.info_outline,
                      () {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 