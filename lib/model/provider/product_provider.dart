import 'package:flutter/cupertino.dart';
import 'package:pappi_store/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _productList = [
    ProductModel(
      prodId: 'p1',
      prodTitle: 'Red Shirt',
      prodDesc: 'A red shirt - it is pretty red!',
      prodPrice: 29.99,
      prodImage:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductModel(
      prodId: 'p2',
      prodTitle: 'Trousers',
      prodDesc: 'A nice pair of trousers.',
      prodPrice: 59.99,
      prodImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductModel(
      prodId: 'p3',
      prodTitle: 'Yellow Scarf',
      prodDesc: 'Warm and cozy - exactly what you need for the winter.',
      prodPrice: 19.99,
      prodImage:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductModel(
      prodId: 'p4',
      prodTitle: 'A Pan',
      prodDesc: 'Prepare any meal you want.',
      prodPrice: 49.99,
      prodImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<ProductModel> get productList {
    return [..._productList];
  }

  List<ProductModel> get favProds {
    return _productList.where((element) => element.isFav).toList();
  }

  ProductModel findById(String id) {
    return _productList.firstWhere((element) => element.prodId == id);
  }

  void addProductItem() {
    //_productList.add(value);
    notifyListeners();
  }
}
