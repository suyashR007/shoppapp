import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/order.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import 'package:shoppapp/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDERS'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, i) =>
                  Ordertile(order: orderData.orders[i]),
            ),
    );
  }
}
