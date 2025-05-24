import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/account/account_screen.dart';
import '../screens/promotions/promotions_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/restaurant/restaurant_details_screen.dart';
import '../screens/help/help_center_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/account/addresses_screen.dart';
import '../screens/account/payment_methods_screen.dart';
import '../screens/account/add_address_screen.dart';
import '../screens/account/add_payment_method_screen.dart';
import '../screens/orders/order_details_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/account':
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case '/promotions':
        return MaterialPageRoute(builder: (_) => const PromotionsScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminScreen());
      case '/restaurant-details':
        return MaterialPageRoute(
          builder: (_) => const RestaurantDetailsScreen(),
          settings: settings,
        );
      case '/help-center':
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case '/orders':
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case '/addresses':
        return MaterialPageRoute(builder: (_) => const AddressesScreen());
      case '/payment-methods':
        return MaterialPageRoute(builder: (_) => const PaymentMethodsScreen());
      case '/add-address':
        return MaterialPageRoute(builder: (_) => const AddAddressScreen());
      case '/edit-address':
        // TODO: Create EditAddressScreen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Edit Address Screen - Coming Soon')),
          ),
          settings: settings,
        );
      case '/add-payment-method':
        return MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen());
      case '/edit-payment-method':
        // TODO: Create EditPaymentMethodScreen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Edit Payment Method Screen - Coming Soon')),
          ),
          settings: settings,
        );
      case '/order-details':
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
