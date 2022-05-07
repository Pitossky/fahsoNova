import 'package:flutter/material.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:pappi_store/screens/manage_prod_screen.dart';
import 'package:pappi_store/widgets/custom_drawer.dart';
import 'package:pappi_store/widgets/user_prod_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-prod';

  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final prodInfo = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                ManageProductScreen.routeName,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  userProdId: prodInfo.productList[i].prodId,
                  userProdTitle: prodInfo.productList[i].prodTitle,
                  userImgUrl: prodInfo.productList[i].prodImage,
                ),
                const Divider(),
              ],
            ),
            itemCount: prodInfo.productList.length,
          ),
        ),
      ),
    );
  }
}
