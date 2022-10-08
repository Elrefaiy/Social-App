import 'package:flutter/material.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddPostScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var textController = TextEditingController();

   return BlocConsumer<AppCubit, AppStates>(
     listener: (context, state){},
     builder: (context, state){
       return Scaffold(
         appBar: AppBar(
           title: Text(
             'Create Post',
             style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontSize: 19),
           ),
           actions: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextButton(onPressed: (){
                 if(AppCubit.get(context).postImage == null){
                   AppCubit.get(context).createPost(
                       dateTime: DateTime.now().toString(),
                       text: textController.text);
                 }else{
                   AppCubit.get(context).uploadPostImage(
                       dateTime: DateTime.now().toString(),
                       text: textController.text,
                   );
                 }
                 Navigator.pop(context);
               },
                   child: Text('Post', style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue, fontSize: 14),)),
             )
           ],
           titleSpacing: 5,
         ),

         body: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(children: [
               if(state is CreatePostLoadingState)
                Padding(
                 padding: const EdgeInsets.only(bottom: 10),
                 child: LinearProgressIndicator(),
               ),
               Row(
                 children: [
                   CircleAvatar(
                     radius: 27,
                     backgroundImage: NetworkImage(
                         AppCubit.get(context).userModel.image
                     ),
                   ),
                   SizedBox(width: 10,),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Text(AppCubit.get(context).userModel.name, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                           Icon(Icons.check_circle, color: Colors.blue,size: 16,),
                         ],
                       ),
                       Row(
                         children: [
                           Icon(Icons.public, size: 13, color: Colors.grey[600],),
                           Text(' Public', style: Theme.of(context).textTheme.caption.copyWith(height: 1.3),),
                         ],
                       )
                     ],
                   ),
                 ],
               ),
               SizedBox(height: 10,),
               Container(
                 height: 100,
                 child: TextFormField(
                   controller: textController,
                   style: TextStyle(fontSize: 18),
                   // keyboardType: TextInputType.multiline,
                   decoration: InputDecoration(
                     hintText: 'what is on your mind, ... ',
                     border: InputBorder.none,
                   ),
                 ),
               ),

               if(AppCubit.get(context).postImage != null)
                 Stack(
                   alignment: AlignmentDirectional.topEnd,
                   children: [
                     Container(
                       color: Colors.grey,
                       child: Image(
                         image: FileImage(AppCubit.get(context).postImage),
                         fit: BoxFit.cover,
                         height: 220,
                         width: double.infinity,
                       ),
                     ),
                     IconButton(
                         icon: Icon(Icons.close, color: Colors.white, size: 20,),
                         onPressed: (){
                           AppCubit.get(context).removePostImage();
                         }),
                   ],
                 ),
               Row(
                 children: [
                   Expanded(
                     child: TextButton(onPressed: (){
                       AppCubit.get(context).getPostImage();
                     },
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.photo_outlined),
                           Text('add photo'),
                         ],),
                     ),
                   ),
                   Container(height: 30, width: 1, color: Colors.grey,),
                   Expanded(
                     child: TextButton(onPressed: (){},
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.tag),
                           Text('add tags'),
                         ],),
                     ),
                   ),
                 ],),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Container(
                   height: 1,
                   color: Colors.grey[300],
                 ),
               ),
             ],),
           ),
         ),
       );
     }
   );
  }
}
