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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
   

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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          initialData: false,
          stream: _productBloc.outCreated,
          builder: (context, snapshot) {
            return Text(snapshot.data ? 'Editar produto' : 'Criar produto');
          },
        ),
        actions: [
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if(snapshot.data == true)
                return StreamBuilder<bool>(
                  stream: _productBloc.outLoading,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: snapshot.data ? null : () {
                        _productBloc.deleteProduct();
                        Navigator.of(context).pop();
                      }
                    );
                  },
                );
              
              return Container();
              
            },
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct
              );
            },
          )
        ],
      ),
      body: Stack(
              children: [
                Form(
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
            StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  )
                );
              },
            )
          ],
      )
    );
  }

  void saveProduct() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();

      ScaffoldMessenger.of(_scaffoldKey.currentContext).removeCurrentSnackBar();
      
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
        .showSnackBar(SnackBar(backgroundColor: Colors.pinkAccent, content: Text('Salvando produto...',
          style: TextStyle(color: Colors.white))));

      bool success = await _productBloc.saveProduct();

      ScaffoldMessenger.of(_scaffoldKey.currentContext).removeCurrentSnackBar();
      
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
        .showSnackBar(SnackBar(backgroundColor: Colors.pinkAccent,
          content: Text(success ? 'Salvo com sucesso!' : 'Erro ao salvar produto',
          style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 5)));
    }
  }
}