import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/edit_products_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_providers.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(
              create:(context)=> Auth()),
         ChangeNotifierProxyProvider<Auth,Products>(
           create: (ctx)=>Products(null,null,[]),
           update: (ctx,auth,prevProducts)=>Products(auth.userId,auth.token,prevProducts==null?[]:prevProducts.getItem),),
          ChangeNotifierProvider(
              create:(context)=> Cart()),
          ChangeNotifierProxyProvider<Auth,Orders>(
              create:(context)=> Orders(null,null,[]),
               update:(ctx,auth,prevOrders)=>Orders(auth.userId,auth.token,prevOrders==null?[]:prevOrders.orders) ,),

        ],
      child:Consumer<Auth>(
        builder: (ctx,auth,_){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Lato',
              accentColor: Colors.deepOrange,
            ),
            home:auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                   future: auth.tryAutoLogin() ,
                   builder: (context,authResultSnapshot)=>
                   authResultSnapshot.connectionState==
                       ConnectionState.waiting? SplashScreen() : AuthScreen(),),
            routes: {
              ProductDetailScreen.routeName:(context) => ProductDetailScreen(),
              CartScreen.routeName:(context)=> CartScreen(),
              OrdersScreen.routeName: (context)=> OrdersScreen(),
              UserProductsScreen.routeName: (context)=> UserProductsScreen(),
              EditProductsScreen.routeName: (context) => EditProductsScreen(),
            },
          );
        },
      )
    );
  }
}


