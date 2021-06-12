import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_products_screen.dart';


import 'package:shopping_app/widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_providers.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName ='/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {

    //final products = Provider.of<Products>(context);
    return Scaffold(
      appBar:AppBar(title:Text('Your Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductsScreen.routeName);
          }, icon:Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx,snapShot)=>snapShot.connectionState==ConnectionState.waiting?Center(
          child: CircularProgressIndicator(),
        ) :RefreshIndicator(
          onRefresh:()=>_refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx,products,_)=>Padding(
              padding: EdgeInsets.all(8),
              child:products.getItem.isEmpty?Center(
                child: Text('You have no products!'),
              ) :ListView.builder(
                itemBuilder: (_,index){
                  return Column(
                    children: [
                      UserProductItem(products.getItem[index].id,products.getItem[index].title,products.getItem[index].imageUrl),
                      Divider(),
                    ],
                  );
                },
                itemCount: products.getItem.length,
              ),
            ),
          )
        ),
      ),
    );
  }
}
