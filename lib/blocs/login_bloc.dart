import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with LoginValidators implements BlocBase {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);

  @override
  void addListener(listener) {
    
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
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