import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/cart.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/cart_screen.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import 'package:shoppapp/widgets/products_grid.dart';
import 'package:shoppapp/widgets/badge.dart';

enum fliterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // }); this is a kind of approach
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          actions: [
            Consumer<Cart>(
              builder: (_, cart, ch) => Badges(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                color: Colors.deepPurple,
                value: cart.itemCount.toString(),
              ),
            ),
            PopupMenuButton(
                onSelected: (fliterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == fliterOptions.favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: const Icon(Icons.more_vert_outlined),
                itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: fliterOptions.favorites,
                          child: Text(
                            'ONLY FAVORITES',
                          )),
                      PopupMenuItem(
                          value: fliterOptions.all,
                          child: Text(
                            'SHOW ALL',
                          ))
                    ]),
          ],
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ProductsGrid(
                favOpt: _showOnlyFavorites,
              ));
  }
}
