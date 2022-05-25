import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Product>(context).fetchAndSetproducts();wont work

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Product>(context).fetchAndSetproducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Product>(context).fetchAndSetproducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Product>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dhaba Mart'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedvalue) {
                setState(() {
                  if (selectedvalue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ch,
              ),
              value: cartData.itemCount.toString(),
              // color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
