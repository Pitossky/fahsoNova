import 'package:flutter/cupertino.dart';

import '../cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _cartItem = {};

  Map<String, CartItemModel> get cartItem {
    return {..._cartItem};
  }

  int get cartItemCount {
    return _cartItem.length;
  }

  double get totalCartAmt {
    var totalAmt = 0.0;
    _cartItem.forEach((key, value) {
      totalAmt += value.cartItemPrice * value.cartItemQty;
    });
    return totalAmt;
  }

  void addCartItem(String prodId, double prodPrice, String prodTitle) {
    if (_cartItem.containsKey(prodId)) {
      _cartItem.update(
          prodId,
          (value) => CartItemModel(
                cartItemId: value.cartItemId,
                cartItemTitle: value.cartItemTitle,
                cartItemQty: value.cartItemQty + 1,
                cartItemPrice: value.cartItemPrice,
              ));
    } else {
      _cartItem.putIfAbsent(
          prodId,
          () => CartItemModel(
                cartItemId: DateTime.now().toString(),
                cartItemTitle: prodTitle,
                cartItemQty: 1,
                cartItemPrice: prodPrice,
              ));
    }
    notifyListeners();
  }

  void removeCartItem(String prodId) {
    _cartItem.remove(prodId);
    notifyListeners();
  }

  void removeSingleCartItem(String prodId) {
    if (!_cartItem.containsKey(prodId)) {
      return;
    }
    if (_cartItem[prodId]!.cartItemQty > 1) {
      _cartItem.update(
        prodId,
        (currCartItem) => CartItemModel(
          cartItemId: currCartItem.cartItemId,
          cartItemTitle: currCartItem.cartItemTitle,
          cartItemQty: currCartItem.cartItemQty - 1,
          cartItemPrice: currCartItem.cartItemPrice,
        ),
      );
    } else {
      _cartItem.remove(prodId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItem = {};
    notifyListeners();
  }
}
