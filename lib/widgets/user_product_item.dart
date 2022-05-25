import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Product>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                      content: Text(
                    'Deleting Failed!',
                    textAlign: TextAlign.center,
                  )));
                }
              },
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
