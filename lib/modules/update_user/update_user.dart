import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/shared/components/components.dart';

class UpdateUserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var model = AppCubit.get(context).userModel;
    var profileImage = AppCubit.get(context).profileImage;
    var coverImage = AppCubit.get(context).coverImage;
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var bioController = TextEditingController();
    nameController.text = model.name;
    phoneController.text = model.phone;
    bioController.text = model.bio;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 19),),
              titleSpacing: 5,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(onPressed: (){
                  AppCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                  Navigator.pop(context);
                  toastBuilder(message: 'profile info successfully updated ', type: ToastType.Success);
                  }, child: Text('Update')),
              )
            ],
          ),
          body: Column(children: [
            if(state is UpdateUserLoadingState)
              Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinearProgressIndicator(),
            ),
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
                            image: coverImage==null ? NetworkImage(
                                model.cover
                            ) : FileImage(coverImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                            icon: Icon(Icons.camera_alt_outlined, size: 17, color: Colors.white,),
                            onPressed: (){
                              AppCubit.get(context).getCoverImage();
                            }),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: profileImage == null ? NetworkImage(
                              model.image
                          ) : FileImage(profileImage),
                        ),
                      ),
                      CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined, size: 17, color: Colors.white,),
                              onPressed: (){
                                AppCubit.get(context).getProfileImage();
                              }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                if(AppCubit.get(context).profileImage != null)
                  Expanded(
                  child: OutlinedButton(
                    onPressed: (){
                      AppCubit.get(context).uploadProfilePic(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text);
                    },
                    child: Text('Upload Profile Image', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12, color: Colors.blue),),
                  ),
                ),
                SizedBox(width: 5,),
                if(AppCubit.get(context).coverImage != null)
                  Expanded(
                  child: OutlinedButton(
                    onPressed: (){
                      AppCubit.get(context).uploadCoverPic(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text);
                    },
                    child: Text('Upload Cover Image', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12, color: Colors.blue),),
                  ),
                ),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: inputField(
                label: 'Name',
                preIcon: Icon(Icons.person_outline_rounded),
                controller: nameController,
                type: TextInputType.text,
                submit: (){},
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: inputField(
                label: 'Bio',
                preIcon: Icon(Icons.info_outline_rounded),
                controller: bioController,
                type: TextInputType.text,
                submit: (){},
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: inputField(
                label: 'phone',
                preIcon: Icon(Icons.local_phone_outlined),
                controller: phoneController,
                type: TextInputType.number,
                submit: (){},
              ),
            ),
          ],),
        );
      },
    );
  }
}