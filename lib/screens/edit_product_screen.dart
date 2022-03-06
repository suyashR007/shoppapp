import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/product.dart';
import 'package:shoppapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlDocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  // var _isInit = true;
  // var _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlDocusNode.addListener(() {
      _updateImageUrl;
    });
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context)!.settings.arguments as String;
  //     _editedProduct =
  //         Provider.of<Products>(context, listen: false).findById(productId);
  //     _initValues = {
  //       'id': _editedProduct.id,
  //       'title': _editedProduct.title,
  //       'description': _editedProduct.description,
  //       'price': _editedProduct.price.toString(),
  //       // 'imageUrl': _editedProduct.imageUrl,
  //       'imageUrl': '',
  //     };
  //     _imageUrlController.text = _editedProduct.imageUrl;
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _imageUrlDocusNode.removeListener(() {
      _updateImageUrl();
    });
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    _imageUrlDocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlDocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    // final isValidator = _form.currentState!.validate();
    // if (isValidator) {
    //   return;
    // }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    //if (_editedProduct.id.isEmpty) {
    // Provider.of<Products>(context, listen: false)
    //     .updateProduct(_editedProduct.id.toString(), _editedProduct);
    //} //else {
    Provider.of<Products>(context, listen: false)
        .addProduct(_editedProduct)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        //initialValue: _initValues['title'],
                        //initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Title'),
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
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //initialValue: _initValues['price'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus();
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
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //initialValue: _initValues['description'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description'),
                        maxLines: 3,
                        //textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionNode,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.deepPurple,
                            )),
                            child: Container(
                              child: _imageUrlController.text.isEmpty
                                  ? const Text(
                                      'Enter a URL',
                                      textAlign: TextAlign.center,
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initValues['imageUrl'],
                              decoration: const InputDecoration(
                                labelText: 'IMAGE URL',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlDocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => _saveForm(),
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
                      )
                    ],
                  )),
            ),
    );
  }
}
