import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return ConditionalBuilder(
          condition: AppCubit.get(context).posts.length > 0,
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image(
                        image: NetworkImage(
                            'https://image.freepik.com/free-photo/close-up-young-beautiful-couple-having-fun-together_273609-35422.jpg'
                        ),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text('Contact with Friends',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 26, color: Colors.white, shadows: [BoxShadow(blurRadius: 20,)])),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 5,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => postBuilder(AppCubit.get(context).posts[index],context,index),
                    separatorBuilder: (context, index) => SizedBox(height: 10,),
                    itemCount: AppCubit.get(context).posts.length),
                SizedBox(height: 200,),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      }
    );
  }
}
