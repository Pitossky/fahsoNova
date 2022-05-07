import 'package:flutter/material.dart';
import 'package:pappi_store/model/cart_model.dart';
import 'package:pappi_store/model/order_model.dart';
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
                      '\$${cartAmt.totalCartAmt.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge!
                            .color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartAmt: cartAmt),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartAmt,
  }) : super(key: key);

  final CartProvider cartAmt;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var loadData = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartAmt.totalCartAmt <= 0 || loadData)
          ? null
          : () async {
              setState(() {
                loadData = true;
              });
              await Provider.of<OrderProvider>(context, listen: false).addOrder(
                widget.cartAmt.cartItem.values.toList(),
                widget.cartAmt.totalCartAmt,
              );
              setState(() {
                loadData = true;
              });
              widget.cartAmt.clearCart();
            },
      child: loadData
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
