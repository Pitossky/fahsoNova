import 'package:flutter/material.dart';
import 'package:pappi_store/screens/cart_screen.dart';
import 'package:pappi_store/screens/manage_prod_screen.dart';
import 'package:pappi_store/screens/orders_screen.dart';
import 'package:pappi_store/screens/user_prod_screen.dart';
import 'package:provider/provider.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:pappi_store/screens/product_details.dart';
import 'package:pappi_store/screens/product_overview.dart';

import 'model/cart_model.dart';
import 'model/order_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColorLight: Colors.white,
          //accentColor: Colors.red,
          fontFamily: 'Lato',
        ),
        home: ProductOverview(),
        routes: {
          ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          UserProductScreen.routeName: (_) => const UserProductScreen(),
          ManageProductScreen.routeName: (_) => const ManageProductScreen(),
        },
      ),
    );
  }
}
