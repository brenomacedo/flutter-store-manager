import 'package:flutter/material.dart';
import 'package:loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.store_mall_directory, size: 160, color: Colors.pinkAccent),
                InputField(hint: 'Usuário', icon: Icons.person_outline, obscure: false),
                InputField(hint: 'Senha', icon: Icons.lock_outline, obscure: true),
                SizedBox(height: 32),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Entrar'),
                    style: ButtonStyle(
                      backgroundColor:  MaterialStateProperty.all(Colors.pinkAccent),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}