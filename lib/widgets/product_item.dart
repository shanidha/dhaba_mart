import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);

    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // header: Text(
        //   title,
        //   textAlign: TextAlign.center,
        // style: TextStyle(
        //   background: Paint()..color=Colors.white,
        //   ),),

        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (ctx) => ProductDetailScreen(),
            //     settings: RouteSettings(arguments: id)));
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),

        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Products>(
            builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                },
                color: Theme.of(context).colorScheme.secondary),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.price,
                  product.title,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to the Cart!',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
