import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BlocBase {

  final _usersController = BehaviorSubject();

  Map<String, Map<String, dynamic>> _users = {};

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUserListener();
  }

  void _addUserListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;

        switch(change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.doc.data();
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.doc.data());
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]['subscription'] = _firestore.collection('users')
      .doc(uid).collection('orders').snapshots()
      .listen((orders) async {
        int numOrders = orders.docs.length;
        double money = 0.0;
        for(DocumentSnapshot d in orders.docs) {
          DocumentSnapshot order = await _firestore.collection('orders').doc(d.id).get();

          if(order.data() == null) continue;

          money += order.data()['totalPrice'];
        }

        _users[uid].addAll({ "money": money, "orders": numOrders });

        _usersController.add(_users.values.toList());
      });
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }
  
  @override
  void addListener(listener) {
  }

  @override
  void dispose() {
    _usersController.close();
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
  }

  @override
  void removeListener(listener) {
  }

  
  
}