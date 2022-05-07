import 'package:flutter/material.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:pappi_store/screens/cart_screen.dart';
import 'package:pappi_store/widgets/badge.dart';
import 'package:pappi_store/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';
import '../widgets/product_gridview.dart';

enum TabOptions { favourites, all }

class ProductOverview extends StatefulWidget {
  ProductOverview({Key? key}) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showFavsOnly = false;
  var _initialData = true;
  var _loadData = false;

  @override
  void didChangeDependencies() {
    if (_initialData) {
      setState(() {
        _loadData = true;
      });
      Provider.of<ProductProvider>(context).fetchProducts().then(
            (_) => setState(() {
              _loadData = false;
            }),
          );
    }
    _initialData = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pappi Store'),
        actions: [
          PopupMenuButton(
            onSelected: (TabOptions value) {
              setState(() {
                if (value == TabOptions.favourites) {
                  _showFavsOnly = true;
                } else {
                  _showFavsOnly = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Show Favourite Products'),
                value: TabOptions.favourites,
              ),
              const PopupMenuItem(
                child: Text('Show All Products'),
                value: TabOptions.all,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) {
              return Badge(
                value: cart.cartItemCount.toString(),
                child: ch,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart,),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _loadData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGridView(
              showFavs: _showFavsOnly,
            ),
    );
  }
}
