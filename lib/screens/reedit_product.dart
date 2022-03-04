import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/product.dart';
import 'package:shoppapp/providers/products_provider.dart';

class ReEditProduct extends StatefulWidget {
  static const routeName = '/reedit-product-screen';

  const ReEditProduct({Key? key}) : super(key: key);

  @override
  State<ReEditProduct> createState() => _ReEditProductState();
}

class _ReEditProductState extends State<ReEditProduct> {
  final _form = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValidator = _form.currentState!.validate();
    _form.currentState!.save();
    Provider.of<Products>(context)
        .updateProduct(_editedProduct.id.toString(), _editedProduct);
    Navigator.pop(context);
  }

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
                initialValue: _initValues['title'],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title can\'t be Empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value.toString(),
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  Focus.of(context).requestFocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price Field Cant be EMPTY';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter a Valid Number';
                  }
                  if (double.tryParse(value)! <= 0) {
                    return 'Please Enter a Number Greater then 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value.toString()),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Description'),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Description';
                  }
                  if (value.length > 100) {
                    return 'Should be less  then 100 characters';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value.toString(),
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 10, top: 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.deepPurple,
                    )),
                    child: Container(
                      child: _imageUrlController.text.isEmpty
                          ? const Text(
                              'ENTER A URL',
                              textAlign: TextAlign.center,
                            )
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'IMAGE URL',
                        border: OutlineInputBorder(),
                      ),
                      controller: _imageUrlController,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter the ImageURL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Plese enter a valid URL';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value.toString(),
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
