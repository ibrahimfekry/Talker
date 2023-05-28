import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talki/shared/bloc_observer/bloc_observer.dart';
import 'package:talki/shared/constants/theme.dart';
import 'firebase_options.dart';
import 'layout/home_layout_screen.dart';
import 'shared/cubit/layout_cubt/layout_cubit.dart';
import 'modules/add_screen/add_screen.dart';
import 'modules/calls_screen/calls_screen.dart';
import 'shared/cubit/chat_cubit/chat_cubit.dart';
import 'modules/chat_screen/chat_screen.dart';
import 'modules/chats_screen_history/chats_screen_history.dart';
import 'modules/contact_screen/contact_screen.dart';
import 'modules/forget_password_screen/forget_password_screen.dart';
import 'modules/groups_screen/groups_screen.dart';
import 'modules/login_Screen/Login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/cubit/login_register_cubit/login_cubit.dart';
import 'modules/menu_screen/menu_screen.dart';
import 'modules/pdf_screen/pdf_screen.dart';
import 'modules/register_screen/register_screen.dart';
import 'modules/reset_password_screen/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360,690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child){
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LayoutCubit()),
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => ChatCubit()),
            ],
            child: MaterialApp(
              routes: {
                LoginScreen.id:(context)=> LoginScreen(),
                RegisterScreen.id:(context)=> RegisterScreen(),
                ForgetPasswordScreen.id:(context)=> ForgetPasswordScreen(),
                ResetPasswordScreen.id:(context)=> const ResetPasswordScreen(),
                HomeLayoutScreen.id:(context)=>  HomeLayoutScreen(),
                ChatsScreenHistory.id:(context)=> ChatsScreenHistory(),
                CallsScreen.id : (context) =>  CallsScreen(),
                AddScreen.id : (context) => const AddScreen(),
                GroupsScreen.id : (context) => const GroupsScreen(),
                MenuScreen.id : (context) => const MenuScreen(),
                ChatScreen.id : (context) => ChatScreen(),
                PdfScreen.id : (context) => PdfScreen(),
                ContactScreen.id : (context) => ContactScreen(),
              },
              theme: darkTheme,
              debugShowCheckedModeBanner: false,
              //home: AuthenticationScreen(),
              initialRoute: LoginScreen.id,
            ),
          );
        }
    );
  }
}


