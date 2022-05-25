import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';

import '../providers/product.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);

    final product = showFavs ? productData.favoriteItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: product.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
      // ProductItem(product[i].id, product[i].title, product[i].imageUrl),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
