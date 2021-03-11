import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/blocs/product_bloc.dart';
import 'package:loja/validators/product_validator.dart';
import 'package:loja/widgets/images_widget.dart';


class ProductScreen extends StatefulWidget {

  final String categoryId;
  final DocumentSnapshot product;
  ProductScreen({ this.categoryId, this.product });

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {

  final _formKey = GlobalKey<FormState>();

  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product) :
    _productBloc = ProductBloc(product: product, categoryId: categoryId);
   

  @override
  Widget build(BuildContext context) {

    final fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16
    );

    InputDecoration fieldDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text('Criar produsto'),
        actions: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if(_formKey.currentState.validate()) {
                _formKey.currentState.save();
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder(
          stream: _productBloc.outData,
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Container();
            }

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text('Imagens', style: TextStyle(color: Colors.grey[850], fontSize: 12)),
                ImagesWidget(
                  context: context,
                  initialValue: snapshot.data['images'],
                  onSaved: _productBloc.saveImages,
                  validator: validateImages,
                ),
                TextFormField(
                  initialValue: snapshot.data['title'],
                  style: fieldStyle,
                  decoration: fieldDecoration('Título'),
                  onSaved: _productBloc.saveTitle,
                  validator: validateTitle,
                ),
                TextFormField(
                  initialValue: snapshot.data['description'],
                  style: fieldStyle,
                  decoration: fieldDecoration('Descrição'),
                  maxLines: 6,
                  onSaved: _productBloc.saveDescription,
                  validator: validateDescription,
                ),
                TextFormField(
                  initialValue: snapshot.data['price']?.toStringAsFixed(2),
                  style: fieldStyle,
                  decoration: fieldDecoration('Preço'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: _productBloc.savePrice,
                  validator: validatePrice,
                )
              ],
            );
          },
        )
      ),
    );
  }
}