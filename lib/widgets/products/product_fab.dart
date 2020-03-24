import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';
import 'package:sellers_bay/models/product.dart';
import 'package:sellers_bay/scoped-models/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFAB extends StatefulWidget {
  final Product product;
  ProductFAB(this.product);
  @override
  _ProductFABState createState() => _ProductFABState();
}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'contact',
                //mini: true,
                onPressed: () async {
                  final url = 'mailto:${widget.product.userEmail}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not Launch';
                  }
                },
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'favorite',
                //mini: true,
                onPressed: () {
                  model.toggleProductFavoriteStatus(model.selectedProduct);
                },
                child: Icon(
                  model.selectedProduct.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: 'options',
            //mini: true,
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    child: Icon(_controller.isDismissed
                        ? Icons.more_vert
                        : Icons.close),
                    transform:
                        Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  );
                }),
          ),
        ],
      );
    });
  }
}
