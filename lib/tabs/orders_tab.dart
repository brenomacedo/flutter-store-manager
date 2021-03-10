import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:loja/blocs/orders_bloc.dart';
import 'package:loja/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final OrdersBloc _ordersBloc = BlocProvider.getBloc<OrdersBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        builder: (context, snapshot) {

          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));

          if(snapshot.data.length == 0)
            return Center(child: Text('Nenhum pedido encontrado!', style: TextStyle(color: Colors.pinkAccent)));

          return ListView.builder(
            itemBuilder: (context, index) {
              return OrderTile(order: snapshot.data[index]);
            },
            itemCount: snapshot.data.length,

          );
        },
        stream: _ordersBloc.outOrders,
      )
    );
  }
}