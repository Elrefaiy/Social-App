import 'package:flutter/material.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/modules/login/login.dart';
import 'package:social_application/modules/update_user/update_user.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var model = AppCubit.get(context).userModel;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){
        if(state is LogoutSuccessState){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context)=> LoginScreen()),
                  (route) => false);
        }
      },
      builder: (context, state){

        return Column(
          children: [
            Container(
              height: 210,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              model.cover
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          model.image
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(model.name, style: Theme.of(context).textTheme.bodyText1,),
            Text(model.bio, style: Theme.of(context).textTheme.caption,),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){},
                      child: Column(
                        children: [
                          Text('310'),
                          Text('post', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: (){},
                      child: Column(
                        children: [
                          Text('821'),
                          Text('followers', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){},
                      child: Column(
                        children: [
                          Text('453'),
                          Text('following', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text('Edit Profile', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, color: Colors.blue),),
                    ),
                  ),
                  SizedBox(width: 5,),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateUserScreen()));
                    },
                    child: Icon(Icons.edit_outlined, size: 20,),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}