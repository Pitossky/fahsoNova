import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String? prodId;
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

  void _setValue(bool newValue) {
    isFav = newValue;
    notifyListeners();
  }

  Future<void> changeFavourite() async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/products/$prodId.json',
    );
    try {
      final favResponse = await http.patch(
        url,
        body: jsonEncode({
          'isFavorite': isFav,
        }),
      );
      if (favResponse.statusCode >= 400) {
        _setValue(oldStatus);
      }
    } catch (errorData) {
      _setValue(oldStatus);
    }
  }
}
