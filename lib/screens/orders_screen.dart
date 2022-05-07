import 'package:flutter/material.dart';
import 'package:pappi_store/model/order_model.dart';
import 'package:pappi_store/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderDet = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: orderDet.orders.length,
        itemBuilder: (_, i) => OrderItem(
          ordData: orderDet.orders[i],
        ),
      ),
    );
  }
}
