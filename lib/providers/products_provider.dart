import 'package:flutter/material.dart';
import 'package:shoppapp/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    //Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 50,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 100,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 20,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 70,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items {
    // if(_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favitems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
        'https://shoppapp-ba408-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final List<Product> loadedProduct = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(Product(
          id: prodID,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          //isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shoppapp-ba408-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isfavorite': product.isFavorite,
          }));
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shoppapp-ba408-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isfavorite': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      //print('...');
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        'https://shoppapp-ba408-default-rtdb.firebaseio.com/products/$id.json');
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    http.delete(url).then((_)  {
      //existingProduct = existingProduct
    }).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
    });
    _items.removeAt(existingProductIndex);
   // _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
// var _showFavoritesOnly = false;

// void showFavoritesOnly() {
//   _showFavoritesOnly = true;
//   notifyListeners();
// }
//
// void showAll() {
//   _showFavoritesOnly = false;
//   notifyListeners();
// }

}
