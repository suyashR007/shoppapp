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
import 'package:shoppapp/screens/splash_screen.dart';
import 'package:shoppapp/screens/user_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (context) => Products(),
              update: (context, auth, previousProducts) => Products(
                  authToken: auth.token.toString(), userId: auth.userId)),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => Orders(),
              update: (context, auth, previousOrders) => Orders(
                  authToken: auth.token.toString(), userId: auth.userId)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: "Shopping_App",
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : const AuthScreen()),
            routes: {
              ProductDetails.routeName: (context) => const ProductDetails(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              ReEditProduct.routeName: (context) => const ReEditProduct(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          ),
        ));
  }
}
