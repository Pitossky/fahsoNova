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
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final prodInfo = Provider.of<ProductProvider>(context);

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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductProvider>(
                  builder: (context, prodInfo, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemBuilder: (_, i) => Column(
                          children: [
                            UserProductItem(
                              userProdId: prodInfo.productList[i].prodId,
                              userProdTitle:
                                  prodInfo.productList[i].prodTitle.toString(),
                              userImgUrl:
                                  prodInfo.productList[i].prodImage.toString(),
                            ),
                            const Divider(),
                          ],
                        ),
                        itemCount: prodInfo.productList.length,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
