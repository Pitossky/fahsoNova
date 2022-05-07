import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pappi_store/model/http_exception.dart';
import 'package:pappi_store/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<ProductModel> _productList = [];

  List<ProductModel> get productList {
    return [..._productList];
  }

  List<ProductModel> get favProds {
    return _productList.where((element) => element.isFav).toList();
  }

  ProductModel findById(String id) {
    return _productList.firstWhere((element) => element.prodId == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/products.json',
    );
    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductModel> loadedProducts = [];
      fetchedData.forEach((productId, value) {
        loadedProducts.add(
          ProductModel(
            prodId: productId,
            prodTitle: value['title'],
            prodDesc: value['description'],
            prodPrice: value['price'],
            prodImage: value['imageUrl'],
            isFav: value['isFavorite'],
          ),
        );
      });
      _productList = loadedProducts;
      notifyListeners();
    } catch (errData) {
      rethrow;
    }
  }

  Future<void> addProductItem(ProductModel prod) async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/products.json',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.prodTitle,
          'description': prod.prodDesc,
          'imageUrl': prod.prodImage,
          'price': prod.prodPrice,
          'isFavorite': prod.isFav,
        }),
      );
      final newProduct = ProductModel(
        prodId: json.decode(response.body)['name'],
        prodTitle: prod.prodTitle,
        prodDesc: prod.prodDesc,
        prodPrice: prod.prodPrice,
        prodImage: prod.prodImage,
      );
      _productList.add(newProduct);
      notifyListeners();
    } catch (errData) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, ProductModel newProd) async {
    final prodIndex = _productList.indexWhere(
      (e) => e.prodId == id,
    );
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/products/$id.json',
    );
    await http.patch(
      url,
      body: jsonEncode({
        'title': newProd.prodTitle,
        'description': newProd.prodDesc,
        'imageUrl': newProd.prodImage,
        'price': newProd.prodPrice,
      }),
    );
    _productList[prodIndex] = newProd;
    notifyListeners();
  }

  Future<void> deleteProd(String id) async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/products/$id.json',
    );
    final currentProdIndex = _productList.indexWhere((e) => e.prodId == id);
    ProductModel? currentProd = _productList[currentProdIndex];
    _productList.removeAt(currentProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _productList.insert(
        currentProdIndex,
        currentProd,
      );
      notifyListeners();
      throw HttpExceptionError(
        errorMessage: 'Could not delete product',
      );
    }
    currentProd = null;
  }
}
