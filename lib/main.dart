import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pappi_store/model/provider/auth_provider.dart';
import 'package:pappi_store/screens/splash_screen.dart';
import 'package:pappi_store/screens/auth_screen.dart';
import 'package:pappi_store/screens/cart_screen.dart';
import 'package:pappi_store/screens/manage_prod_screen.dart';
import 'package:pappi_store/screens/orders_screen.dart';
import 'package:pappi_store/screens/user_prod_screen.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:pappi_store/screens/product_details.dart';
import 'package:pappi_store/screens/product_overview.dart';
import 'model/provider/cart_provider.dart';
import 'model/provider/order_provider.dart';

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
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProxyProvider<AuthenticationProvider, ProductProvider>(
          create: (_) => ProductProvider(
            [],
            authenticationToken: '',
            userId: '',
          ),
          update: (_, authProv, prod) => ProductProvider(
            prod == null ? [] : prod.productList,
            authenticationToken: authProv.token.toString(),
            userId: authProv.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthenticationProvider, OrderProvider>(
          create: (_) => OrderProvider(
            [],
            authToken: '',
            userId: '',
          ),
          update: (_, authProv, orderProv) => OrderProvider(
            orderProv == null ? [] : orderProv.orders,
            authToken: authProv.token.toString(),
            userId: authProv.userId,
          ),
        ),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProv, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColorLight: Colors.white,
              //accentColor: Colors.red,
              fontFamily: 'Lato',
            ),
            home: authProv.authStatus
                ? const ProductOverview()
                : FutureBuilder(
                    future: authProv.autoLogIn(),
                    builder: (context, snap) =>
                        snap.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthenticationScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (_) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (_) => const CartScreen(),
              OrdersScreen.routeName: (_) => const OrdersScreen(),
              UserProductScreen.routeName: (_) => const UserProductScreen(),
              ManageProductScreen.routeName: (_) => const ManageProductScreen(),
            },
          );
        },
      ),
    );
  }
}
