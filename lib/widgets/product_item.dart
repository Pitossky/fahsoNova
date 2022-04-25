import 'package:flutter/material.dart';
import 'package:pappi_store/model/cart_model.dart';
import 'package:pappi_store/model/product_model.dart';
import 'package:pappi_store/screens/product_details.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prodMod = Provider.of<ProductModel>(context, listen: false);
    final cartMod = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: prodMod.prodId,
          ),
          child: Image.network(
            prodMod.prodImage,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<ProductModel>(
            builder: (context, prodMod, _) => IconButton(
              icon: Icon(
                prodMod.isFav ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                prodMod.changeFavourite();
              },
              //color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cartMod.addCartItem(
                prodMod.prodId,
                prodMod.prodPrice,
                prodMod.prodTitle,
              );
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            prodMod.prodTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
