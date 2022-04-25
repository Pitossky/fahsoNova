import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String prodId;
  final String prodTitle;
  final String prodDesc;
  final double prodPrice;
  final String prodImage;
  bool isFav;

  ProductModel({
    required this.prodId,
    required this.prodTitle,
    required this.prodDesc,
    required this.prodPrice,
    required this.prodImage,
    this.isFav = false,
  });

  void changeFavourite() {
    isFav = !isFav;
    notifyListeners();
  }
}
