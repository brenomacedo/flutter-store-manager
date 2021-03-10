import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {

  final DocumentSnapshot order;

  OrderTile({ this.order });

  final states = [
    "", "Em preparação", "Em transporte", "Aguardando entrega", "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text('#${order.id.substring(order.id.length - 7, order.id.length)} - ${states[order.data()['status']]}',
            style: TextStyle(color: order.data()['status'] != 4 ? Colors.grey[850] : Colors.green)),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data()['products'].map<Widget>((p) {
                      return ListTile(
                        title: Text(p['product']['title']+ ' - ' + p['size']),
                        subtitle: Text(p['category'] + '/' + p['pid']),
                        trailing: Text(p['quantity'].toString(), style: TextStyle(fontSize: 20)),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Excluir', style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Regredir', style: TextStyle(color: Colors.grey[850])),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Avançar', style: TextStyle(color: Colors.green)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}