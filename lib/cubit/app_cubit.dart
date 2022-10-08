import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_application/models/message_model.dart';
import 'package:social_application/models/post_model.dart';
import 'package:social_application/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_application/modules/chat/chat_screen.dart';
import 'package:social_application/modules/home/home_screen.dart';
import 'package:social_application/modules/settings/settings_screen.dart';
import 'package:social_application/modules/users/users_screen.dart';
import 'package:social_application/shared/conistants/conistants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_application/shared/network/remote/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chat',
    'Users',
    'Profile',
  ];

  UserModel userModel;
  void getUser() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState());
    });
  }

  void logout(){
    uId = '';
    CacheHelper.removeData(key: 'uId')
        .then((value) {
          emit(LogoutSuccessState());
    })
        .catchError((error){
      emit(LogoutErrorState());
    });
  }

  void changeIndex(int index) {
    if (index == 1) getAllUsers();
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfilePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetProfilePicErrorState());
    }
  }

  File coverImage;
  var coverPicker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await coverPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetProfilePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetProfilePicErrorState());
    }
  }

  void uploadProfilePic({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
        emit(UploadProfilePicSuccessState());
      }).catchError((error) {
        emit(UploadProfilePicErrorState());
      });
    }).catchError((error) {
      emit(UploadProfilePicErrorState());
    });
  }

  void uploadCoverPic({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        emit(UploadCoverPicSuccessState());
      }).catchError((error) {
        emit(UploadCoverPicErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverPicErrorState());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String image,
    String cover,
  }) {
    UserModel model = UserModel(
      name: name,
      email: userModel.email,
      image: image ?? userModel.image,
      cover: cover ?? userModel.cover,
      uId: userModel.uId,
      isEmailVerified: userModel.isEmailVerified,
      phone: phone,
      bio: bio,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUser();
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  File postImage;
  var postPicker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await postPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetPostPicErrorState());
    }
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  }) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        emit(CreatePostSuccessState());
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  }) {
    emit(CreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  void addComment(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel.uId)
        .set({
      'comment': comment,
    }).then((value) {
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postIds = [];
  List<int> likes = [];
  List<int> comments = [];
  List<TextEditingController> commentController = [];

  void getPosts() {
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postIds.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          commentController.add(TextEditingController());
        }).catchError((error) {});
      });

      emit(GetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetPostsErrorState());
    });
  }

  List<UserModel> users = [];
  void getAllUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetAllUsersErrorState());
      });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      //emit(GetMessageSuccessState());
    });
  }
}
