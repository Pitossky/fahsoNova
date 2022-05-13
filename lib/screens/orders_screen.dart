import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pappi_store/widgets/custom_drawer.dart';

import '../model/provider/order_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _orderFuture;

  Future _getOrderFuture() {
    return  Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _orderFuture = _getOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderDet = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<OrderProvider>(
                builder: (context, orderDet, child) {
                  return ListView.builder(
                    itemCount: orderDet.orders.length,
                    itemBuilder: (_, i) => OrderItem(
                      ordData: orderDet.orders[i],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
