import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de loja',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}