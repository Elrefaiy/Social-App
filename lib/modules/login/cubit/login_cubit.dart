import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    @required email,
    @required password
  }){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      // print(value.user.email);
      emit(LoginSuccessState(value.user.uid));
    }).catchError((error){
      emit(LoginErrorState(error));
    });
  }

  var sufIcon = Icon(Icons.visibility_off);
  bool isVisible = true;

  void changePasswordVisibility(){
    isVisible = !isVisible;
    sufIcon = isVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility) ;
    emit(ChangeVisibilityState());
  }
}