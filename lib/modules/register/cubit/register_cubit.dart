import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_application/models/users_model.dart';
import 'register_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth
        .instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(name: name, email: email, phone: phone, uId: value.user.uid);
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  void createUser({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
  }) {
    UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        image: 'https://i.stack.imgur.com/gMbrL.jpg',
        cover: 'https://cdn.hovia.com/app/uploads/Blue-Illustrated-Landscape-Mountains-Wallpaper-Mural.jpg',
        bio: 'write your bio ...',
        isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error));
    });
  }

  var sufIcon = Icon(Icons.visibility_off);
  bool isVisible = true;
  void changePasswordVisibility() {
    isVisible = !isVisible;
    sufIcon = isVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
    emit(ChangeRegisterVisibilityState());
  }
  
}
