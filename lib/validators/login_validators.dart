import 'dart:async';

class LoginValidators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains('@')) {
        sink.add(email);
      } else {
        sink.addError('Insira um email válido');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length <= 6)
        return sink.addError('Insira uma senha maior!');
      
      sink.add(password);
    }
  );
}