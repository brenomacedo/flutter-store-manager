import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/blocs/category_bloc.dart';

class EditCategoryDialog extends StatefulWidget {

  final DocumentSnapshot category;
  EditCategoryDialog({ this.category });

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {

  final CategoryBloc _categoryBloc;
  final TextEditingController _controller;

  _EditCategoryDialogState({ DocumentSnapshot category }) :
    _categoryBloc = CategoryBloc(category),
    _controller = TextEditingController(
      text: category != null ? category.data()['title'] : ''
    );

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: GestureDetector(
                child: StreamBuilder(
                  stream: _categoryBloc.outImage,
                  builder: (context, snapshot) {
                    if(snapshot.data != null)
                      return CircleAvatar(
                        child: snapshot.data is File ?
                          Image.file(snapshot.data, fit: BoxFit.cover):
                          Image.network(snapshot.data, fit: BoxFit.cover),
                        backgroundColor: Colors.transparent,
                      );
                    

                    return Icon(Icons.image);
                  },
                )
              ),
              title: TextField(
                controller: _controller,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                  stream: _categoryBloc.outDelete,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Container();
                    return TextButton(onPressed: snapshot.data ? () {
                      
                    } : null, child: Text('Excluir', style: TextStyle(color: Colors.red)));
                  },
                ),
                TextButton(onPressed: () {
                  
                }, child: Text('Salvar', style: TextStyle(color: Colors.green)))
              ],
            )
          ],
        ),
      ),
    );
  }
}