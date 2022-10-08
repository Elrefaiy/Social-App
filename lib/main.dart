import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_application/cubit/app_cubit.dart';
import 'package:social_application/cubit/app_states.dart';
import 'package:social_application/layout/social_layout.dart';
import 'package:social_application/modules/login/login.dart';
import 'package:social_application/shared/conistants/conistants.dart';
import 'package:social_application/shared/network/remote/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/register/cubit/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  var token = await FirebaseMessaging.instance.getToken();

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    print(token);

  });

  // when click message to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });

  // background fcm
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{}
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');

  if(uId == null){
    widget = LoginScreen();
  }else{
    widget = HomeLayout();
  }

  runApp(MyApp(uId, widget));
}

class MyApp extends StatelessWidget {

  final String uId;
  final Widget startWidget;

  MyApp(this.uId, this.startWidget);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> AppCubit()..getUser()..getPosts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:ThemeData(
              primaryColor: Colors.blueAccent,
              appBarTheme: AppBarTheme(
                backwardsCompatibility: false,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                color: Colors.white,
                elevation: 0,
              ),
              textTheme: TextTheme(
                headline1: GoogleFonts.pacifico(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),

                bodyText1: GoogleFonts.mPlusRounded1c(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey[400],
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.white,
            ),
            home: startWidget,
          );
        }
      ),
    );
  }
}
