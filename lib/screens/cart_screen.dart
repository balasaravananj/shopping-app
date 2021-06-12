import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart-screen';
  final scaffoldKey= GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cart =Provider.of<Cart>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('Your Cart'),),
      body: cart.items.isEmpty?Center(child: Text('Your cart is empty !'),):Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor:Theme.of(context).primaryColor,),
                  FlatButton(
                      child: Text('ORDER NOW'),
                      onPressed: ()async{
                        if(cart.items.isNotEmpty)
                        await Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(),cart.totalAmount );
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Your order has been placed!',textAlign: TextAlign.center,))
                        );
                        cart.clearCart();
                      },
                       textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10 ,
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context,index){
                  return CartItem(
                      productId: cart.items.keys.toList()[index],
                      id:cart.items.values.toList()[index].id,
                      title:cart.items.values.toList()[index].title ,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity);
                },
                 itemCount: cart.itemCount,),
          )
        ],
      ),
    );
  }
}
