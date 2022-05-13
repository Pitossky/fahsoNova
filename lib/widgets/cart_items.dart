import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/provider/cart_provider.dart';

class CartItems extends StatelessWidget {
  final String cartItemId;
  final double cartItemPrice;
  final int cartItemQty;
  final String prodTitle;
  final String prodId;

  const CartItems({
    Key? key,
    required this.cartItemId,
    required this.cartItemPrice,
    required this.cartItemQty,
    required this.prodTitle,
    required this.prodId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItemId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Please confirm your action'),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('YES'),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text('NO'),
              ),
            ],
          ),
      ),
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeCartItem(prodId);
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        //margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$cartItemPrice'),
                ),
              ),
            ),
            title: Text(prodTitle),
            subtitle: Text('Total: \$${(cartItemPrice * cartItemQty)}'),
            trailing: Text('$cartItemQty x'),
          ),
        ),
      ),
    );
  }
}
