import 'package:flutter/cupertino.dart';

class CartItemModel {
  final String cartItemId;
  final String cartItemTitle;
  final int cartItemQty;
  final double cartItemPrice;

  CartItemModel({
    required this.cartItemId,
    required this.cartItemTitle,
    required this.cartItemQty,
    required this.cartItemPrice,
  });
}

