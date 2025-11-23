import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';
import 'theme.dart';
import 'screens/payment_screen.dart';
import 'screens/admin_home_screen.dart';

// ⭐ ADD THIS IMPORT
import 'screens/signup_screen.dart';

void main() {
  runApp(const HelloFoodApp());
}

class HelloFoodApp extends StatelessWidget {
  const HelloFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GATserve',
        theme: appTheme,
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),

          // ⭐ ADD SIGNUP ROUTE HERE
          SignUpScreen.routeName: (_) => const SignUpScreen(),

          HomeScreen.routeName: (_) => const HomeScreen(),
          ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          PaymentScreen.routeName: (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            final total = args is double ? args : 0.0;
            return PaymentScreen(totalAmount: total);
          },
        },
      ),
    );
  }
}
