import 'dart:async';

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Chandni Chowk, Delhi',
          style: TextStyle(color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.allProducts[productIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                placeholder: AssetImage('assets/food.jpg'),
                height: 300.0,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(product.title),
              ),
              _buildAddressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
