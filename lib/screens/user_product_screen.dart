import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';
import '../screens/cart_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_products';
  Future<void> _refreshproducts(BuildContext context) async {
    await Provider.of<Product>(context, listen: false)
        .fetchAndSetproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Product>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshproducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducts(context),
                    child: Consumer<Product>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
