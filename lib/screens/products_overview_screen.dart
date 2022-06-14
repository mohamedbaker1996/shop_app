import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/Cart.dart';

enum filterOptions {
  Favourite,
  All,
}

class ProuductOverviewScreen extends StatefulWidget {
  static const routeName = 'products_overview_screen';

  @override
  State<ProuductOverviewScreen> createState() => _ProuductOverviewScreenState();
}

class _ProuductOverviewScreenState extends State<ProuductOverviewScreen> {
  var _showFavourite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //  Provider.of<Products>(context).fetchAndSetProducts(); // won't work without setting listen to false
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();    ------- would work fine
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
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
    //final productsContainer = Provider.of<Products>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favourite) {
                  // productsContainer.showFavouritOnly();
                  _showFavourite = true;
                } else {
                  _showFavourite = false;
                  // productsContainer.showAll();
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Show Favourite'),
                value: filterOptions.Favourite,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: filterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavourite),
    );
  }
}
