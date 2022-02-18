import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import 'package:shoppapp/widgets/user_product_item.dart';
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGE PRODUCT'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (context, i) => UserProductItem(
            title: productData.items[i].title,
            imageUrl: productData.items[i].imageUrl,
          ),
        ),
      ),
    );
  }
}
