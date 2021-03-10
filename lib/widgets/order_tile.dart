import 'package:flutter/material.dart';
import 'package:loja/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text('#651651 - Entregue', style: TextStyle(color: Colors.green)),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Camiseta Preta P'),
                        subtitle: Text('camisetas/bla bla'),
                        trailing: Text('2', style: TextStyle(fontSize: 20)),
                        contentPadding: EdgeInsets.zero,
                      )
                    ],
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