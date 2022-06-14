import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/splash_screen.dart';
import '../widgets/edit_product_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/Cart.dart';
import '../providers/orders.dart';
import '../screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import '/screens/products_overview_screen.dart';
import 'providers/products.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, perviousProducts) => Products(
              auth.token ??
                  '', // insted of null check opreator cause it will give exception
              auth.userId ?? '',
              perviousProducts == null ? [] : perviousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, perviouseOrders) => Orders(
              auth.token,
              auth.userId,
              perviouseOrders == null ? [] : perviouseOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomePageTransitionBuilder(),
              TargetPlatform.iOS: CustomePageTransitionBuilder(),
            }),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProuductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            // ProuductOverviewScreen.routeName: (ctx) => ProuductOverviewScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
