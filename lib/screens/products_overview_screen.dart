import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_providers.dart';


import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions{
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites=false;
  var _isInit=true;
  var _isLoading=false;

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading=true;
      });
      Provider.of<Products>(context).getAndSetProducts().then((_){
        setState(() {
          _isLoading=false;
        });
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }
  

  @override
  Widget build(BuildContext context) {
   //final productsContainer=Provider.of<Products>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue==FilterOptions.Favourites){
                  _showOnlyFavourites=true;
                }
                else{
                  _showOnlyFavourites=false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_)=>[
              PopupMenuItem(child:  Text('Only Favourites!'),value: FilterOptions.Favourites,),
              PopupMenuItem(child:  Text('Show all!'),value: FilterOptions.All,),

            ],
          ),
          Consumer<Cart>(
            builder: (_,cart,ch){
              return   Badge(
                child: ch,
                value: cart.itemCount.toString(),
              );
            },
            child:IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed:(){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              } ,
            ) ,
          ),


        ],
      ),
      body:_isLoading?Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text('Please Wait!'),
          ],
        ),
      ) :ProductsGrid(_showOnlyFavourites),
      drawer: AppDrawer(),
    );
   }
}


