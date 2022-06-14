import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //that approch is to make sure no new future created if the widget rebuilds
  late Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // it would be an infint loop
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: AppDrawer(),
      // futureBuilder is the elegant way insted of using statless widget and isloading
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('No Orders Yet!'),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                        itemBuilder: (ctx, i) =>
                            OrderItem(ordersData.orders[i]),
                        itemCount: ordersData.orders.length,
                      ));
            }
          }
        },
      ),
    );
  }
}
