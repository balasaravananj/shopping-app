import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName ='/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isLoading = false;

  @override
  void initState(){
    Future.delayed(Duration.zero).then((_)async{
          setState((){
            _isLoading=true;
             });
       await Provider.of<Orders>(context,listen: false).getAndSetOrders();
          setState((){
            _isLoading=false;
          });
    } );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final ordersData = Provider.of<Orders>(context,listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Your Orders'),),
      drawer: AppDrawer(),
      body:_isLoading?Center(
        child: CircularProgressIndicator(),)
          :ordersData.orders.isNotEmpty?ListView.builder(
          itemBuilder: (ctx,index){
            return OrderItem(ordersData.orders[index]);
          },
          itemCount: ordersData.orders.length ,):Center(
        child: Text('No orders yet!'),
      ),
    );
  }
}
