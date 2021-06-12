import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../providers/products_providers.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title,this.imageUrl);


  @override
  Widget build(BuildContext context) {
    final scaffold= Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
       backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),color: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductsScreen.routeName,
              arguments: id);
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),color: Theme.of(context).errorColor,
            onPressed: () {
                showDialog(
                 context: context,
                  builder: (ctx)=>AlertDialog(
                    key: ValueKey(id),
                    title: Text('Are you sure?'),
                    content: Text('Do you want to delete this item?'),
                    actions: [
                      FlatButton(
                          onPressed: (){
                            Navigator.of(ctx).pop();
                      },
                          child: Text('No'),),
                      FlatButton(
                        onPressed:() async{
                          try{
                            Navigator.of(ctx).pop();
                            await Provider.of<Products>(context,listen: false).deleteProduct(id);
                          }catch(error){
                            scaffold.showSnackBar(
                                SnackBar(
                                   duration: Duration(seconds: 2),
                                    content: Text('Failed to delete!',textAlign: TextAlign.center,),
                                )
                            );
                          }
                        },
                        child: Text('Yes'),),
                    ],
                  ),
                );
            },
          )
        ],
      ),
    );
  }
}
