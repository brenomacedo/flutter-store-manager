import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader({ this.order });

  @override
  Widget build(BuildContext context) {

    final UserBloc _userBloc = BlocProvider.getBloc<UserBloc>();
    final user = _userBloc.getUser(order.data()['clientId'])['name'];
    final address = _userBloc.getUser(order.data()['clientId'])['address'];

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$user'),
              Text('$address')
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Produtos: R\$${order.data()['productsPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500)),
            Text('Total: R\$${order.data()['totalPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }
}