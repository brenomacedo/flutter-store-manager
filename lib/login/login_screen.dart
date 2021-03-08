import 'package:flutter/material.dart';
import 'package:loja/blocs/login_bloc.dart';
import 'package:loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

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
                InputField(hint: 'Usuário', icon: Icons.person_outline, obscure: false,
                  stream: _loginBloc.outEmail, onChanged: _loginBloc.changeEmail),
                InputField(hint: 'Senha', icon: Icons.lock_outline, obscure: true,
                  stream: _loginBloc.outPassword, onChanged: _loginBloc.changePassword),
                SizedBox(height: 32),
                StreamBuilder(
                  builder: (context, snapshot) {
                    return Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: snapshot.hasData ? () {} : null,
                        child: Text('Entrar'),
                        style: ButtonStyle(
                          backgroundColor:  MaterialStateProperty.resolveWith<Color>((state) {
                            if(state.contains(MaterialState.disabled)) {
                              return Colors.pinkAccent.withAlpha(140);
                            } else {
                              return Colors.pinkAccent;
                            }
                          }),
                        ),
                      ),
                    );
                  },
                  stream: _loginBloc.outSubmitValid,
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