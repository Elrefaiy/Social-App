import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
    listener: (context, state){},
    builder: (context, state){
      return ConditionalBuilder(
        condition: AppCubit.get(context).users.length > 0,
        builder: (context) => ListView.separated(
          itemBuilder: (context, index) => chatItem(AppCubit.get(context).users[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: AppCubit.get(context).users.length,
        ),
        fallback: (context) => Center(child: CircularProgressIndicator(),),
      );
    });
  }
}