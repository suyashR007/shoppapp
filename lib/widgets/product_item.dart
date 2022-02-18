import 'package:flutter/material.dart';
import 'package:shoppapp/providers/cart.dart';
import 'package:shoppapp/providers/product.dart';
import 'package:shoppapp/screens/product_detail.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  const ProductItem({
    Key? key,
    // required this.id, required this.title, required this.imageUrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: product.id);
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
      footer: GridTileBar(
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItem(
              product.id,
              product.price,
              product.title,
            );
            //Scaffold.of(context).showSnackBar(snackbar);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
              content: const  Text('ADDED ITEM TO CART',),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cart.removeItem((product.id));
                },
              ),
            ));
          },
        ),
        leading: Consumer<Product>(
          builder: (context, product, child) => IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
          ),
        ),
        backgroundColor: Colors.black54,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
