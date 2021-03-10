import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria {
  READY_FIRST, READY_LAST
}

class OrdersBloc extends BlocBase {

  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> _orders = [];

  OrdersBloc() {
    _addOrdersListener();
  }

  SortCriteria _criteria;

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String oid = change.doc.id;

        switch(change.type) {
          case DocumentChangeType.added:
            _orders.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == oid);
            _orders.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == oid);
            break;
        }
      });

      _sort();
    });
  }

  void setOrderCriteria(SortCriteria sortCriteria) {
    _criteria = sortCriteria;
    _sort();
  }

  void _sort() {
    switch(_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a.data()['status'];
          int sb = b.data()['status'];

          if(sa < sb) return 1;
          if(sa > sb) return -1;
          return 0;

        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a, b) {
          int sa = a.data()['status'];
          int sb = b.data()['status'];

          if(sa > sb) return 1;
          if(sa < sb) return -1;
          return 0;

        });
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    super.dispose();
    _ordersController.close();
  }
}