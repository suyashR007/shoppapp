import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppapp/providers/order.dart';

class Ordertile extends StatefulWidget {
  final OrderItem order;

  const Ordertile({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<Ordertile> createState() => _OrdertileState();
}

class _OrdertileState extends State<Ordertile> {
  var _expended = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height:
          _expended ? min(widget.order.product.length * 20.0 + 120, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.order.amount.toString()),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expended ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expended = !_expended;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: const EdgeInsets.symmetric(
                horizontal: 3,
                vertical: 4,
              ),
              height: _expended
                  ? min(widget.order.product.length * 20.0 + 20, 100)
                  : 0,
              child: ListView(
                  children: widget.order.product
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x${prod.price}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
