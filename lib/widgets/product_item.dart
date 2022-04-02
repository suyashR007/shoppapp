import 'package:flutter/material.dart';
import 'package:shoppapp/providers/auth.dart';
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
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: product.id);
        },
        child: Hero(
          tag: product.id,
          child: FadeInImage(
            placeholder:
                const AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        // Image.network(
        //   product.imageUrl,
        //   fit: BoxFit.fill,
        // ),
      ),
      footer: GridTileBar(
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItem(
              product.id.toString(),
              product.price,
              product.title,
            );
            //Scaffold.of(context).showSnackBar(snackbar);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                'ADDED ITEM TO CART',
              ),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cart.removeItem((product.id.toString()));
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
              product.toggleFavoriteStatus(
                  authData.token.toString(), authData.userId.toString());
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
