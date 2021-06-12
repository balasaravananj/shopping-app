import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String productId;
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    @required this.productId,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity
});

  @override
  Widget build(BuildContext context) {


    return Dismissible(
      confirmDismiss: (direction){
           return showDialog(
               context: context,
               builder: (ctx)=> AlertDialog(
                 title: Text('Are you sure?'),
                 content: Text('Do you want to remove this item from the cart?'),
                 actions: [
                   FlatButton(child: Text('No'),onPressed: (){
                     Navigator.of(ctx).pop(false);
                   },),
                   FlatButton(onPressed:(){
                     Navigator.of(ctx).pop(true);
                   } , child: Text('Yes'))
                 ],

               )
           );
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: FlatButton.icon(
          label: Text('Delete this item!',style: TextStyle(color: Colors.white),),
          icon: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading:Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(7),
                child: FittedBox(
                    child: Text('₹${price}',style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),)
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ₹${(price*quantity).toStringAsFixed(2)}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
