import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/modules/add_post/add_post_screen.dart';
import 'package:social_application/shared/style/icon_broken.dart';
class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          appBar: AppBar(
            title: Text(AppCubit.get(context).titles[AppCubit.get(context).currentIndex], style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19)),
            titleSpacing: 20,
            actions: [
              if(AppCubit.get(context).currentIndex != 3)
                IconButton(icon: Icon(IconBroken.Notification, size: 27,), onPressed: (){}),
              if(AppCubit.get(context).currentIndex != 3)
                IconButton(icon: Icon(IconBroken.Search, size: 25,), onPressed: (){}),
              if(AppCubit.get(context).currentIndex == 3)
                IconButton(icon: Icon(IconBroken.Setting, size: 27,),
                    onPressed: (){
                      AppCubit.get(context).logout();
                }),
            ],
          ),
          body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index){
              AppCubit.get(context).changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat),label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(IconBroken.User), label: 'Users'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Profile,), label: 'Profile'),
            ],
          ),
          floatingActionButton: AppCubit.get(context).currentIndex == 0 ? FloatingActionButton(
            child: Icon(IconBroken.Paper_Plus, size: 32,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostScreen()));
            },
          ) : Container(),
        );
      }
    );
  }
}
