import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';

class Product with ChangeNotifier{

  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required  this.imageUrl,
    @required this.description,
    @required this.price,
    this.isFavourite=false});

  Future<void> toggleFavouriteStatus(String token,String userId)async{
    final oldStatus = isFavourite;
    isFavourite= !isFavourite;
    notifyListeners();
    final url = Uri.parse('Your Database URl');
    try{
      final response=await http.put(url,body: json.encode(
        isFavourite,
      ));
      if(response.statusCode>=400){
        isFavourite= oldStatus;
        notifyListeners();
        throw HttpException('Cant add to favourites');
      }
    }catch(error){
      isFavourite= oldStatus;
      notifyListeners();
      throw error;
    }
}

}