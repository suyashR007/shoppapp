import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import 'package:shoppapp/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (context, i) => UserProductItem(
                            id: productData.items[i].id,
                            title: productData.items[i].title,
                            imageUrl: productData.items[i].imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
