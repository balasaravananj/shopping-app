import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItems{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems({
    @required this.id,
    @required this.amount,
    @required  this.products,
    @required  this.dateTime

});
}

class Orders with ChangeNotifier{

  List<OrderItems> _orders=[];
  final String authToken;
  final String userId;

  Orders(this.userId,this.authToken,this._orders);


  List<OrderItems> get orders{
    return [..._orders];
  }

  Future<void> getAndSetOrders()async{
    final url=Uri.parse('Your Database URl');
    final response =await http.get(url);
    final List<OrderItems> loadedOrder=[];
    final extractedOrder = json.decode(response.body) as Map<String,dynamic>;
    if(extractedOrder==null){
      return;
    }
    extractedOrder.forEach((orderId, order) {
      loadedOrder.add(OrderItems(
          id: orderId,
          amount: order['amount'],
          products: (order['products'] as List<dynamic>)
              .map((item) =>
            CartItem(
              id: item['id'],
              quantity: item['quantity'],
              price: item['price'],
              title: item['title'],
            )
          ).toList(),
          dateTime: DateTime.parse(order['dateTime'])));
    });
    _orders=loadedOrder.reversed.toList();
    notifyListeners();
  }

Future<void> addOrder(List<CartItem> cartProducts,double total)async{
  final url=Uri.parse('Your Database URl');
  final timeStamp=DateTime.now();
  final response = await  http.post(url,body: json.encode({
    'amount':total,
    'products':cartProducts.map((cartProd)=>{
      'id': cartProd.id,
      'title':cartProd.title,
      'quantity':cartProd.quantity,
      'price':cartProd.price,
    }).toList(),
    'dateTime':timeStamp.toIso8601String(),
  }));
    _orders.insert(0,OrderItems(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp)
    );
    notifyListeners();
  }
}