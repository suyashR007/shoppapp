import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/cart.dart';
import 'package:shoppapp/providers/order.dart';
import 'package:shoppapp/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CART'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(label: Text('${cart.totalAmt}')),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) => CartList(
                productId: cart.items.keys.toList()[i],
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: (widget.cart.totalAmt <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cart.items.values.toList(),
                      widget.cart.totalAmt,
                    );
                    widget.cart.clearCart();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: const Text('Order Now'),
          );
  }
}
