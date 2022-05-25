import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/product.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/user_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          // ChangeNotifierProvider.value(
          //   value: Product(),
          // ),
          ChangeNotifierProxyProvider<Auth, Product>(
            update: (ctx, auth, previusProducts) => Product(
                auth.token,
                auth.userId,
                previusProducts == null ? [] : previusProducts.items),
            //previousProduct..authToken = auth.token!,
            // auth.token as String,
            // previousProduct == null ? [] : previousProduct.items),
            create: (_) => Product(null, null, []),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, prevOrders) => Orders(auth.token, auth.userId,
                prevOrders == null ? [] : prevOrders.orders),
            create: (_) => Orders(null, null, []),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'Dhaba Mart',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple,
              ).copyWith(
                secondary: Colors.deepOrange,
              ),
              fontFamily: 'Lato',
            ),
            home: authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
