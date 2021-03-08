import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {
  IDLE, LOADING, SUCCESS, FAIL
}

class LoginBloc with LoginValidators implements BlocBase {

  StreamSubscription _streamSubscription;

  LoginBloc() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if(user != null) {
        if(await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
        FirebaseAuth.instance.signOut();
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<bool> get outSubmitValid => Rx.combineLatest2(outEmail, outPassword, (a, b) => true);
  Stream<LoginState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;


    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((user) async {
  
    }).catchError((error) {
      _stateController.add(LoginState.FAIL);
    });
  }

  @override
  void addListener(listener) {
    
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance.collection('admins').doc(user.uid).get().then((doc) {
      return doc.data() != null;
    }).catchError((error) {
      return false;
    });
  }

  @override
  void notifyListeners() {
    
  }

  @override
  void removeListener(listener) {
    
  }

  @override
  bool get hasListeners => throw UnimplementedError();
}