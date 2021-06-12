
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier{

  final String authToken;
  final String userId;

  Products(this.userId,this.authToken,this._items);

  List<Product> _items = [];

  List<Product> get favouriteItems{
    return [..._items].where((product) => product.isFavourite).toList();
  }

  List<Product> get getItem{

    return [..._items];
  }


  Future<void> getAndSetProducts([bool filterByuser=false]) async {
    final filterString=filterByuser?'orderBy="creatorId"&equalTo="$userId"':'';
    var url=Uri.parse('Your Database URl');
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      final List<Product> loadedProducts=[];
      if(extractedData==null||extractedData['error']!=null){
        print('null check');
        return;
      }
      url = Uri.parse('Your Database URl');
      final favResponse=await http.get(url);
      final favData=json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            description: prodData['description'],
            price: prodData['price'],
          isFavourite: favData==null? false : favData[prodId]??false,
        ));
      });
      _items=loadedProducts;
      notifyListeners();
    }catch(error){
      throw error;
    }

  }

  Future<void> addProducts(Product product) async {
    final url=Uri.parse('Your Database URl');

    try{
      final response =await http.post(url,body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price':product.price,
        'creatorId':userId,
         })
        );
      final newProduct=Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          imageUrl: product.imageUrl,
          description: product.description,
          price: product.price);
      _items.add(newProduct);
       notifyListeners();
    } catch(error){
            throw error;
         }
  }

  Future<void> updateProducts(String id,Product product)async{

    final prodIndex =_items.indexWhere((prod) => prod.id==id);
    if(prodIndex>=0){
      final url=Uri.parse('Your Database URl');
      await http.patch(url,body: json.encode({
        'title':product.title,
        'description':product.description,
        'price':product.price,
        'imageUrl':product.imageUrl
      }));
      _items[prodIndex]=product;
      notifyListeners();
    }
  }

 Future<void> deleteProduct(String id) async {
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    var existingProd =_items[prodIndex];
    final url=Uri.parse('Your Database URl');
    _items.removeAt(prodIndex);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode>=400){
       _items.insert(prodIndex, existingProd);
        notifyListeners();
        throw HttpException('Could not delete this product!');
      }
     existingProd=null;
  }

  Product findById(String id){
    return _items.firstWhere((item) => item.id==id);
  }

}