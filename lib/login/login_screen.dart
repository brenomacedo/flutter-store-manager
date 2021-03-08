import 'package:flutter/material.dart';
import 'package:loja/blocs/login_bloc.dart';
import 'package:loja/home/home_screen.dart';
import 'package:loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch(state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Você não possui os privilégios necessários')
          ));
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch(snapshot.data) {
            case LoginState.LOADING:
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation
              <Color>(Colors.pinkAccent)));
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
              return Center(
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
                                onPressed: snapshot.hasData ? _loginBloc.submit : null,
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
              );
            default:
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation
                <Color>(Colors.pinkAccent)));
          }
          
        },
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}