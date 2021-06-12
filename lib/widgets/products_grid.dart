import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/products_providers.dart';
import './products_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool showOnlyFavourites;
  ProductsGrid(this.showOnlyFavourites);

  @override
  Widget build(BuildContext context) {

  final productsData= Provider.of<Products>(context);
  final products =showOnlyFavourites? productsData.favouriteItems:productsData.getItem;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder:(context,index){
        return ChangeNotifierProvider.value(
          value:products[index],
          child: ProductItem(),
        );

      },
      itemCount: products.length,);
  }
}