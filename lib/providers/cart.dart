import 'package:flutter/material.dart';

import './product.dart';

class CartItem{
  final String title;
  final String id;
  final double price;
   int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required  this.quantity});

}


class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};

  Map<String,CartItem> get items{
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(! _items.containsKey(productId)){
       return;
    }
     if(_items[productId].quantity>1){
       _items.update(productId, (prod) => CartItem(
           id: prod.id,
           title: prod.title,
           price: prod.price,
           quantity: prod.quantity-1)
       );
     }
     else{
       _items.remove(productId);
     }
     notifyListeners();

  }

  double get totalAmount{
    var total= 0.0;
    _items.forEach((key, cartItem) {
      total+=cartItem.price*cartItem.quantity;
    });
    return total;
  }


  void addItem(String productId,double price,String title){
    if(_items.containsKey(productId)){
        _items.update(productId, (existingCardItem) => CartItem(
          id: existingCardItem.id,
          title: existingCardItem.title,
          price: existingCardItem.price,
          quantity: existingCardItem.quantity+1
        ));
    }
    else{
     _items.putIfAbsent
       (productId,
         ()=> CartItem(
             id: DateTime.now().toString(),
             title: title,
             price: price,
             quantity: 1));
    }
    notifyListeners();
  }
  void clearCart(){
    _items ={};
    notifyListeners();
  }

}