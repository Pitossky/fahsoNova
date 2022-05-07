import 'package:flutter/material.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:pappi_store/screens/manage_prod_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String? userProdId;
  final String userProdTitle;
  final String userImgUrl;

  const UserProductItem({
    Key? key,
    required this.userProdId,
    required this.userProdTitle,
    required this.userImgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffSnack = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(userProdTitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userImgUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ManageProductScreen.routeName,
                  arguments: userProdId,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteProd(userProdId.toString());
                } catch (errorData) {
                  scaffSnack.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed!'),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
