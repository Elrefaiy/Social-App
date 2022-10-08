import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/layout/social_layout.dart';
import 'package:social_application/modules/register/cubit/register_cubit.dart';
import 'package:social_application/modules/register/cubit/register_states.dart';
import 'package:social_application/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context)=> RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessState){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeLayout()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Let\'s Get Started',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Register now to contact with your friends!',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        inputField(
                          preIcon: Icon(Icons.person_outline_rounded),
                          label: 'User Name',
                          type: TextInputType.name,
                          controller: nameController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        inputField(
                          preIcon: Icon(Icons.email_outlined, size: 20,),
                          label: 'Email Address',
                          type: TextInputType.emailAddress,
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        inputField(
                          preIcon: Icon(Icons.lock_outline_rounded, size: 20,),
                          sufIcon: IconButton(
                              icon: RegisterCubit.get(context).sufIcon,
                              onPressed: () {
                                RegisterCubit.get(context)
                                    .changePasswordVisibility();
                              }),
                          label: 'Password',
                          type: TextInputType.text,
                          controller: passwordController,
                          isPassword: RegisterCubit.get(context).isVisible,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        inputField(
                          preIcon: Icon(Icons.phone_android_rounded,size: 20,),
                          label: 'Phone',
                          type: TextInputType.phone,
                          controller: phoneController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                              width: 160,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);}
                                  },
                                  child: Text(
                                  'CREATE',
                                  style: TextStyle(fontSize: 20,color: Colors.white),
                                ),
                              ),
                            ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Login'),
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
        },
      ),
    );
  }
}
