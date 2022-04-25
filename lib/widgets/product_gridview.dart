import 'package:flutter/material.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:pappi_store/widgets/product_item.dart';

class ProductGridView extends StatelessWidget {
  final bool showFavs;

  const ProductGridView({
    Key? key,
    required this.showFavs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<ProductProvider>(context);
    final prodItems = showFavs ? prodData.favProds : prodData.productList;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: prodItems[index],
        child: ProductItem(),
      ),
      itemCount: prodItems.length,
    );
  }
}
