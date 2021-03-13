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

  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream;
  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;

  @override
  void dispose() {
    super.dispose();
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }
}