import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase {

  DocumentSnapshot category;

  CategoryBloc(this.category) {
    if(category != null) {
      _titleController.add(category.data()['title']);
      _imageController.add(category.data()['icon']);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
      
  }

  File image;
  String title;

  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();


  Stream<String> get outTitle => _titleController.stream.transform(StreamTransformer<String, String>.fromHandlers(
    handleData: (title, sink) {
      if(title.isEmpty) {
        sink.addError('Insira um titulo');
      } else {
        sink.add(title);
      }
    }
  ));

  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;
  Stream<bool> get submitValid => Rx.combineLatest2(outTitle, outImage, (a, b) => true);

  void setImage(File file) {
    _imageController.add(file);
    image = file;
  }

  void setTitle(String title) {
    _titleController.add(title);
    this.title = title;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }
}