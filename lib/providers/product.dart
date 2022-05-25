import 'dart:convert';

import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'products.dart';

class Product with ChangeNotifier {
  List<Products> _items = [
    //   Products(
    //       id: 'p1',
    //       title: 'Afghani Barbaque Chicken',
    //       description: 'Incredibily Moist and Juicy and tender charcoal chicken',
    //       price: 180.0,
    //       imageUrl:
    //           'https://img.freepik.com/free-photo/indian-afghani-chicken-malai-tikka-is-grilled-murgh-creamy-kabab-served-with-fresh-salad_466689-862.jpg?w=1800'),
    //   Products(
    //       id: 'p2',
    //       title: 'Sundari Barbaque Chicken',
    //       description: 'Hot and Spicy tender charcoal chicken',
    //       price: 170.0,
    //       imageUrl:
    //           'https://e7.pngegg.com/pngimages/828/597/png-clipart-buffalo-wing-barbecue-chicken-fried-chicken-red-hot-blue-barbecue-barbecue-food.png'),
    //   Products(
    //       id: 'p3',
    //       title: 'Kuzhi Manthi',
    //       description: 'Whole roasted chicken served on a bed of delicious Rice',
    //       price: 360.0,
    //       imageUrl:
    //           'https://image.shutterstock.com/image-photo/kuzhimanthi-spicy-manthi-arabic-chicken-260nw-1587533359.jpg'),
    //   Products(
    //       id: 'p4',
    //       title: 'Beef Dhaba Special',
    //       description: 'Hot and dry beef Idichathu dhaba special',
    //       price: 260.0,
    //       imageUrl:
    //           'https://spicerackindia.com/wp-content/uploads/2020/11/maxresdefault.jpg'),
    //   Products(
    //       id: 'p5',
    //       title: 'Special Dhaba Mutton Biriyani',
    //       description:
    //           'Specially done lovable biriyani with juicy and tender Mutton legs and ribs',
    //       price: 580.0,
    //       imageUrl:
    //           'https://5.imimg.com/data5/XT/SE/GLADMIN-51707319/mutton-biryani-500x500.png'),
    //   Products(
    //       id: 'p6',
    //       title: 'Dhaba Thali',
    //       description: 'Super vegetarian Thali With mouth watering receipes',
    //       price: 300.0,
    //       imageUrl:
    //           'https://e7.pngegg.com/pngimages/429/426/png-clipart-thali-food-platter-south-indian-cuisine-vegetarian-cuisine-sambar-menu-food-recipe.png'),
    //   Products(
    //       id: 'p7',
    //       title: 'White Sauce Pasta ',
    //       description:
    //           'YUMMY creamy pasta served with loaded mozeralla cheese and hot gravy',
    //       price: 270.0,
    //       imageUrl:
    //           'https://thumbs.dreamstime.com/z/pasta-white-creamy-sauce-penne-shape-sprinkle-cheese-pasta-white-creamy-sauce-penne-shape-sprinkle-cheese-served-as-183959999.jpg'),
    //   Products(
    //       id: 'p8',
    //       title: 'Fish Barbeque',
    //       description: 'Specially done masala coated Fish Barbeque',
    //       price: 670.0,
    //       imageUrl:
    //           'https://www.pngkit.com/png/full/376-3761235_whole-fish-tilapia-grilled-that-will-make-you.png'),
    //   Products(
    //       id: 'p9',
    //       title: 'Kizhi Poratta',
    //       description:
    //           'Kerala porotta Steamed with juicy and creamy chicken or beef gravy',
    //       price: 240.0,
    //       imageUrl:
    //           'https://www.onmanorama.com/content/dam/mm/en/food/foodie/images/2020/7/15/nidhi-parotta.jpg.transform/onm-articleimage/image.jpg'),
    //   Products(
    //       id: 'p10',
    //       title: 'Shawarma roll',
    //       description: 'Juicy and creative Shawarma roll up in rumali rotti',
    //       price: 80.0,
    //       imageUrl:
    //           'https://thumbnail.imgbin.com/4/18/16/imgbin-shawarma-chicken-tabbouleh-middle-eastern-cuisine-wrap-kebab-vegetable-and-beef-taco-u54eHgvzCCS0jy295Kv4JErnT_t.jpg'),
    // ];
  ];
  //var _showFavoritesOnly = false;

  final String? authToken;
  final String? userId;
  Product(
    this.authToken,
    this.userId,
    this._items,
  );

  // String? _authToken;

  // set authToken(String value) {
  //   _authToken = value;
  // }

  List<Products> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  Products findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  List<Products> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Future<void> fetchAndSetproducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://dhaba-mart-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://dhaba-mart-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Products> loadedproduct = [];
      extractedData.forEach((key, value) {
        loadedproduct.add(
          Products(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavourite:
                favoriteData == null ? false : favoriteData[key] ?? false,
          ),
        );
      });
      _items = loadedproduct;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProducts(Products product) async {
    final url = Uri.parse(
        'https://dhaba-mart-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Products(
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name '],
          title: product.title,
          price: product.price);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }

    // print(error);
    // throw (error);

    //return Future.value();
  }

  Future<void> updateProduct(String id, Products newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://dhaba-mart-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://dhaba-mart-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    //.then((response) {
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete Product');
    }
    existingProduct = null!;
    // }).catchError((_) {

    //  });

    // notifyListeners();
  }
}
