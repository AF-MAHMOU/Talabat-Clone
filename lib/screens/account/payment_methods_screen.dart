import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to manage payment methods'),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Payment Methods',
        showBackButton: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('payment_methods')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: snapshot.data?.docs.isEmpty ?? true
                    ? const Center(
                        child: Text('No payment methods added yet'),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final paymentMethod = snapshot.data!.docs[index];
                          final data =
                              paymentMethod.data() as Map<String, dynamic>;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: Icon(
                                _getPaymentIcon(data['type']),
                                color: Colors.deepOrange,
                              ),
                              title: Text(
                                _formatCardNumber(data['cardNumber'] ?? ''),
                              ),
                              subtitle: Text(
                                '${data['cardHolder'] ?? 'No name'} • Expires ${data['expiryMonth'] ?? 'MM'}/${data['expiryYear'] ?? 'YY'}',
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    // TODO: Navigate to edit payment method screen
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-payment-method',
                                      arguments: {
                                        'paymentMethodId': paymentMethod.id,
                                        'paymentMethod': data,
                                      },
                                    );
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Payment Method'),
                                        content: const Text(
                                          'Are you sure you want to delete this payment method?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await paymentMethod.reference.delete();
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-payment-method');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Add New Payment Method'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getPaymentIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'cash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  String _formatCardNumber(String number) {
    if (number.isEmpty) return 'No card number';
    // Only show last 4 digits
    return '•••• •••• •••• ${number.substring(number.length - 4)}';
  }
} 