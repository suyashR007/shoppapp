import 'package:flutter/material.dart';
import 'package:shoppapp/providers/product.dart';

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
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

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

  @override
  void initState() {
    _imageUrlDocusNode.addListener(() {
      _updateImageUrl;
    });
    // TODO: implement initState
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlDocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState?.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm;
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus();
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value.toString()),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Description'),
                  maxLines: 3,
                  //textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value.toString(),
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
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
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value.toString(),
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
/* Expanded(
  child: TextFormField(
    decoration: InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _imageUrlController,
    onEditingComplete: () {
      setState(() {});
    },
  )
),*/
