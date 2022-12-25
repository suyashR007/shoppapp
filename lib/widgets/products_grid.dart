import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool favOpt;
  const ProductsGrid({
    Key? key,
    required this.favOpt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = favOpt ? productsData.favitems : productsData.items;
    return GridView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(3),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
            //builder: (context) => products[i];
            value: products[i],
            child: const ProductItem(
                // id: products[i].id,
                // title: products[i].title,
                // imageUrl: products[i].imageUrl
                )));
  }
}
