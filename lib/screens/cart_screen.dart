import 'package:flutter/material.dart';
import 'package:pappi_store/model/cart_model.dart';
import 'package:pappi_store/widgets/cart_items.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartAmt = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartAmt.totalCartAmt}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge!
                            .color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartAmt.cartItemCount,
              itemBuilder: (_, index) => CartItems(
                cartItemId: cartAmt.cartItem.values.toList()[index].cartItemId,
                cartItemPrice:
                    cartAmt.cartItem.values.toList()[index].cartItemPrice,
                cartItemQty:
                    cartAmt.cartItem.values.toList()[index].cartItemQty,
                prodTitle:
                    cartAmt.cartItem.values.toList()[index].cartItemTitle,
                prodId: cartAmt.cartItem.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
