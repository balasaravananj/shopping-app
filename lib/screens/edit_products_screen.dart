import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products_providers.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName ='/edit-products';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode =FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct =Product(
      id: null,
      title: '',
      imageUrl: '',
      description: '',
      price: 0.0,
      isFavourite: false);

  var _initValues={
    'title':'',
    'description':'',
    'imageUrl':'',
    'price':'',

  };


  var _isInit=true;
  var _isLoading=false;


  @override
  void initState(){
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if(prodId!=null){
        _editedProduct = Provider.of<Products>(context,listen: false).findById(prodId);

        _initValues={
          'title':_editedProduct.title,
          'description':_editedProduct.description,
          'price':_editedProduct.price.toString(),
          'imageUrl':'',
        };
        _imageUrlController.text=_editedProduct.imageUrl;
      }
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if((!_imageUrlController.text.startsWith('http')&&
          !_imageUrlController.text.startsWith('https'))||
          (!_imageUrlController.text.endsWith('.jpeg')&&
              !_imageUrlController.text.endsWith('.png')&&
              !_imageUrlController.text.endsWith('.jpg'))){
      return;
      }
      setState(() {
      });
    }

  }


  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async{
    final isValid=_form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if(_editedProduct.id!=null){
      await Provider.of<Products>(context,listen: false).updateProducts(_editedProduct.id,_editedProduct);
    }
    else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong'),
                  actions: [
                    FlatButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Okay'))
                  ],
                ));
      }
      // finally{
      //   setState(() {
      //     _isLoading=false;
      //   });
      //   Navigator.of(context).pop();
      //
      //  }
    }
    setState(() {
        _isLoading=false;
      });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          FlatButton.icon(onPressed:_saveForm, icon: Icon(Icons.save), label: Text('Save'))
        ],
      ),
      body:_isLoading?Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title'
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct=Product(
                      id: _editedProduct.id,
                      title: value,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      isFavourite:_editedProduct.isFavourite);
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                    labelText: 'Price'
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'This field can\'t be empty';
                  }
                  if(double.tryParse(value)==null){
                    return 'Please enter a valid number!';
                  }
                  if(double.parse(value)<=0){
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct=Product(
                      id: _editedProduct.id,
                      isFavourite:_editedProduct.isFavourite,
                      title: _editedProduct.title,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      price: double.parse(value));
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                    labelText: 'Description'
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value.isEmpty){
                    return 'This field can\'t be empty';
                  }
                  if(value.length<10){
                    return 'Description must have atleast 10 characters!';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct=Product(
                      id: _editedProduct.id,
                      isFavourite:_editedProduct.isFavourite,
                      title: _editedProduct.title,
                      imageUrl: _editedProduct.imageUrl,
                      description: value,
                      price: _editedProduct.price);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),
                    child: _imageUrlController.text.isEmpty ? Text('Enter URL'):FittedBox(
                      child: Image.network(_imageUrlController.text),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Image URL'
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted:(_)=> _saveForm(),
                      controller: _imageUrlController,
                      onEditingComplete: (){
                        setState(() {
                        });
                      },
                      focusNode: _imageUrlFocusNode,
                      validator: (value){
                        if(value.isEmpty){
                          return 'This field can\'t be empty';
                        }
                        if(!value.startsWith('http')&& !value.startsWith('https')){
                          return 'Please enter a valid URL';
                        }
                        if(!value.endsWith('.jpeg')&& !value.endsWith('.png')&& !value.endsWith('.jpg')){
                          return 'Please enter a valid Image URL';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _editedProduct=Product(
                            id: _editedProduct.id,
                            isFavourite:_editedProduct.isFavourite,
                            title: _editedProduct.title,
                            imageUrl: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
