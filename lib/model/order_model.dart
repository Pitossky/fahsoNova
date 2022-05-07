import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pappi_store/model/cart_model.dart';
import 'package:http/http.dart' as http;

class OrderModel {
  final String orderId;
  final double orderAmt;
  final List<CartItemModel> prodOrdered;
  final DateTime timeOfOrder;

  OrderModel({
    required this.orderId,
    required this.orderAmt,
    required this.prodOrdered,
    required this.timeOfOrder,
  });
}

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orderList = [];

  List<OrderModel> get orders => [..._orderList];

  Future<void> addOrder(List<CartItemModel> cartProds, double total) async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/orders.json',
    );
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'orderAmt': total,
        'timeOfOrder': timeStamp.toIso8601String(),
        'prodOrdered': cartProds
            .map(
              (e) => {
                'cartItemId': e.cartItemId,
                'cartItemTitle': e.cartItemTitle,
                'cartItemQty': e.cartItemQty,
                'cartItemPrice': e.cartItemPrice,
              },
            )
            .toList(),
      }),
    );
    _orderList.insert(
      0,
      OrderModel(
        orderId: jsonDecode(response.body)['name'],
        orderAmt: total,
        prodOrdered: cartProds,
        timeOfOrder: timeStamp,
      ),
    );
    notifyListeners();
  }
}
