import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../cart_model.dart';
import '../order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orderList = [];
  final String authToken;
  final String userId;

  OrderProvider(
    this._orderList, {
    required this.authToken,
    required this.userId,
  });

  List<OrderModel> get orders => [..._orderList];

  Future<void> fetchOrders() async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
    );
    final orderResponse = await http.get(url);
    final List<OrderModel> loadedOrders = [];
    final orderData = jsonDecode(orderResponse.body) as Map<String, dynamic>?;
    if (orderData == null) {
      return;
    }
    orderData.forEach((orderId, value) {
      loadedOrders.add(
        OrderModel(
          orderId: orderId,
          orderAmt: value['orderAmt'],
          prodOrdered: (value['prodOrdered'] as List<dynamic>)
              .map((e) => CartItemModel(
                    cartItemId: e['cartItemId'],
                    cartItemTitle: e['cartItemTitle'],
                    cartItemQty: e['cartItemQty'],
                    cartItemPrice: e['cartItemPrice'],
                  ))
              .toList(),
          timeOfOrder: DateTime.parse(value['timeOfOrder']),
        ),
      );
    });
    _orderList = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItemModel> cartProds, double total) async {
    final url = Uri.parse(
      'https://pappi-store-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
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
