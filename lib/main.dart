import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/auth.dart';
import 'package:shoppapp/providers/cart.dart';
import 'package:shoppapp/providers/order.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/auth_screen.dart';
import 'package:shoppapp/screens/cart_screen.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:shoppapp/screens/order_screen.dart';
import 'package:shoppapp/screens/product_detail.dart';
import 'package:shoppapp/screens/products_overview_screen.dart';
import 'package:shoppapp/screens/reedit_product.dart';
import 'package:shoppapp/screens/user_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: "Shopping_App",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const AuthScreen(),
        routes: {
          ProductDetails.routeName: (context) => const ProductDetails(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProductScreen.routeName: (context) => const EditProductScreen(),
          ReEditProduct.routeName: (context) => const ReEditProduct(),
          AuthScreen.routeName: (context) => const AuthScreen(),
        },
      ),
    );
  }
}
