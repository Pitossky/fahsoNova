import 'package:pappi_store/model/cart_model.dart';

class OrderModel {
  final String? orderId;
  final double? orderAmt;
  final List<CartItemModel>? prodOrdered;
  final DateTime? timeOfOrder;

  OrderModel({
    required this.orderId,
    required this.orderAmt,
    required this.prodOrdered,
    required this.timeOfOrder,
  });
}

