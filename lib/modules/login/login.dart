import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/layout/social_layout.dart';
import 'package:social_application/modules/login/cubit/login_cubit.dart';
import 'package:social_application/modules/login/cubit/login_states.dart';
import 'package:social_application/modules/register/register.dart';
import 'package:social_application/shared/components/components.dart';
import 'package:social_application/shared/network/remote/cache_helper.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if(state is LoginErrorState) {
              toastBuilder(
                  message: 'Your Email Address or Password is not Correct,'
                      ' please try again.',
                  type: ToastType.Error);
            }else if(state is LoginSuccessState){
              CacheHelper.putData(
                  key: 'uId',
                  value: state.uId)
                  .then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context)=> HomeLayout()),
                            (route) => false);
                  })
                  .catchError((error){});
            }
          },
          builder: (context, state) {
            return Scaffold(
              //appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/login.jpg'),
                            width: 250,),
                          SizedBox(height: 20,),
                          Text(
                            'Welcome Again!',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Login now to browse our hot offers !',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          inputField(
                            preIcon: Icon(Icons.person_outline_rounded, size: 20,),
                            label: 'Email Address',
                            type: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          inputField(
                              preIcon: Icon(Icons.lock_open_rounded, size: 20),
                              sufIcon: IconButton(
                                  icon: LoginCubit.get(context).sufIcon,
                                  onPressed: () {
                                    LoginCubit.get(context)
                                        .changePasswordVisibility();
                                  }),
                              label: 'Password',
                              type: TextInputType.text,
                              controller: passwordController,
                              isPassword: LoginCubit.get(context).isVisible,
                              submit: (value) {
                                if (formKey.currentState.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Spacer(),
                                Text('Forget Password?')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => Container(
                              width: 160,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text('REGISTER'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
      }),
    );
  }
}
