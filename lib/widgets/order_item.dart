import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pappi_store/model/order_model.dart';

class OrderItem extends StatefulWidget {
  final OrderModel ordData;

  const OrderItem({
    Key? key,
    required this.ordData,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded
          ? min(
              widget.ordData.prodOrdered!.length * 20.0 + 130,
              180,
            )
          : 95,
      child: Card(
        //margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.ordData.orderAmt}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy').format(widget.ordData.timeOfOrder!),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: _expanded
                  ? min(
                      widget.ordData.prodOrdered!.length * 20.0 + 30,
                      180,
                    )
                  : 0,
              child: ListView(
                children: widget.ordData.prodOrdered!
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.cartItemTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${e.cartItemQty}x: \$${e.cartItemPrice}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
