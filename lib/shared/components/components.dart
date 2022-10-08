import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/models/message_model.dart';
import 'package:social_application/models/post_model.dart';
import 'package:social_application/models/users_model.dart';
import 'package:social_application/modules/chat/inner_chat_screen.dart';

Widget inputField({
  preIcon,
  @required label,
  @required type,
  @required controller,
  isPassword = false,
  sufIcon,
  Function submit,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal:5.0),
  child:TextFormField(
    cursorWidth: 2,
    cursorHeight: 12,
    style: GoogleFonts.mPlusRounded1c(
      fontSize: 14,
      height: .7,
      fontWeight: FontWeight.w800,
    ),
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      prefixIcon: preIcon,
      suffixIcon: sufIcon,
    ),
    obscureText: isPassword,
    keyboardType: type,
    validator: (value) {
      if (value.isEmpty) return '$label is Empty !';
      return null;
    },
  ),
);

Widget postBuilder(PostModel model, context, index) => Card(
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: NetworkImage(
              '${model.image}'
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${model.name}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                    Icon(Icons.check_circle, color: Colors.blue,size: 16,),
                  ],
                ),
                Text('${model.dateTime}', style: Theme.of(context).textTheme.caption.copyWith(height: 1.3),)
              ],
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.more_horiz_outlined), onPressed: (){}),
          ],
        ),
        SizedBox(height: 10,),
        Text('${model.text}'),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 10),
        //   child: Wrap(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(right:5.0),
        //         child: Container(
        //           height: 20,
        //           child: MaterialButton(
        //             height: 25,
        //             minWidth: 1,
        //             padding: EdgeInsets.zero,
        //             onPressed: (){},
        //             child: Text('#are_you_ready ', style: TextStyle(color: Colors.blue,),),
        //           ),
        //         ),
        //       ),
        //
        //     ],
        //   ),
        // ),
        if(model.postImage != '')
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(image: NetworkImage(
                '${model.postImage}',
              ),
                fit: BoxFit.cover,
              ),)
        ),

        Row(
          children: [
            Expanded(child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red.withOpacity(.8), size: 22,),
                    SizedBox(width: 5,),
                    Text(
                      '${AppCubit.get(context).likes[index]} likes',
                      style: TextStyle(color: Colors.grey, ),)
                  ],
                ),
              ),
              onTap: (){
                AppCubit.get(context).likePost(AppCubit.get(context).postIds[index]);
              },
            ),
            ),
            Expanded(child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.comment, color: Colors.blue.withOpacity(.8), size: 20,),
                    SizedBox(width: 5,),
                    Text('${AppCubit.get(context).comments[index]} comments', style: TextStyle(color: Colors.grey, ),)
                  ],
                ),
              ),
              onTap: (){},
            ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(height: 1, color: Colors.grey[300],),
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
              '${AppCubit.get(context).userModel.image}'
              ),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                controller: AppCubit.get(context).commentController[index],
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'write a comment, ..',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.add_comment_rounded, color: Colors.blue.withOpacity(.8), size: 22,),
                    SizedBox(width: 5,),
                    Text('Comment', style: TextStyle(color: Colors.grey, ),)
                  ],
                ),
              ),
              onTap: (){
                AppCubit.get(context).addComment(AppCubit.get(context).postIds[index], AppCubit.get(context).commentController[index].text);
                AppCubit.get(context).commentController[index].text = '';
                },
            ),
          ],
        ),
      ],
    ),
  ),
  margin: EdgeInsets.symmetric(horizontal: 10),
  elevation: 5,
);

Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child:   Container(color: Colors.grey[400], height: 1,),
);

Widget chatItem(UserModel model, context) => InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> InnerChatScreen(model)));
  },
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundImage: NetworkImage(
              '${model.image}'
          ),
        ),
        SizedBox(width: 10,),
        Text('${model.name}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
      ],
    ),
  ),
);

Widget buildMessage(MessageModel message) => Align(
  alignment: AlignmentDirectional.centerStart,
  child: Container(
    child: Text('${message.text}', style: TextStyle(fontSize: 20, color: Colors.black),),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  ),
);
Widget buildMyMessage(MessageModel message) => Align(
  alignment: AlignmentDirectional.centerEnd,
  child: Container(
    child: Text('${message.text}', style: TextStyle(fontSize: 20, color: Colors.black),),
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  ),
);

enum ToastType {Success, Warning, Error}

void toastBuilder({
  @required String message,
  @required ToastType type,
}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: toastColor(type),
      textColor: Colors.white,
      fontSize: 16.0);
}

Color toastColor(ToastType type){
  switch(type){
    case ToastType.Success :
      return Colors.green;
      break;

    case ToastType.Warning :
      return Colors.yellow;
      break;

    case ToastType.Error :
      return Colors.red;
      break;

    default: return Colors.blue;
  }
}