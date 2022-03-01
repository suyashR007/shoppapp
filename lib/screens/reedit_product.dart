import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/products_provider.dart';

class ReEditProduct extends StatefulWidget {
  static const routeName = '/reedit-product-screen';
  const ReEditProduct({Key? key}) : super(key: key);

  @override
  State<ReEditProduct> createState() => _ReEditProductState();
}

class _ReEditProductState extends State<ReEditProduct> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('somedata'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'title'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Price'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Description'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
