import 'package:flutter/material.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/models/users_model.dart';
import 'package:social_application/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/shared/style/icon_broken.dart';

class InnerChatScreen extends StatelessWidget {

  final UserModel model;
  InnerChatScreen(this.model);

  @override
  Widget build(BuildContext context) {

    var messageController = TextEditingController();

    return Builder(
      builder: (BuildContext context){

        AppCubit.get(context).getMessages(receiverId: model.uId);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state){},
          builder: (context, state){
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          '${model.image}'
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('${model.name}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                  ],
                ),
                titleSpacing: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index){
                            var message = AppCubit.get(context).messages[index];
                            if(AppCubit.get(context).userModel.uId == message.senderId)
                              return buildMyMessage(message);
                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 15,),
                          itemCount: AppCubit.get(context).messages.length),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [BoxShadow(blurRadius: .2)]
                            ),
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: 'type your message here, ...',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        IconButton(
                            icon: Icon(IconBroken.Send, color: Colors.blue,size: 35,),
                            onPressed: (){
                              AppCubit.get(context).sendMessage(
                                  receiverId: model.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
