import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/modules/login_Screen/Login_screen.dart';
import 'package:talki/modules/reset_password_screen/reset_password_screen.dart';
import 'package:talki/shared/constants/constants.dart';
import 'package:talki/shared/cubit/layout_cubt/layout_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../edit_profile/edit_profile.dart';

class MenuScreen extends StatefulWidget {
  static String id = 'MenuScreen';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  void initState() {
    super.initState();
    LoginCubit.get(context).getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if(state is LogoutSuccess || state is SignOutGoogleSuccess){
          LayoutCubit.get(context).pageIndex = 0 ;
          isGoogleEmail = false;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
        }
      },
      builder: (context, state) {
        return Container(
          height: double.infinity,
          alignment: Alignment.topRight,
          child: Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/background_drawer.jpeg')),
                  ),
                  currentAccountPicture: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        image: NetworkImage('${FirebaseAuth.instance.currentUser?.photoURL}'),)
                  ),
                  accountName: DefaultText(
                    text: FirebaseAuth.instance.currentUser?.displayName,
                    fontSize: 14.sp,
                    fontColor: whiteColor,
                  ),
                  accountEmail: DefaultText(
                    text: FirebaseAuth.instance.currentUser?.email,
                    fontSize: 14.sp,
                    fontColor: whiteColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> EditProfileScreen(
                          emailAddress: "${loginCubit.profileData['emailAddress']}",
                          firstName: "${loginCubit.profileData['firstName']}",
                          lastName: "${loginCubit.profileData['lastName']}",
                          date: loginCubit.profileData['date'],
                          urlImage: loginCubit.profileData['urlImage'],
                        ))
                    );
                  },
                  //leading: SvgPicture.asset('assets/images/profile_edit.svg'),
                  title: DefaultText(
                      text: 'Edit profile information',
                      textStyle: Theme.of(context).textTheme.bodyMedium,),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),);
                  },
                  //leading: SvgPicture.asset('assets/images/lock.svg'),
                  title: DefaultText(
                      text: 'Change Password',
                      textStyle: Theme.of(context).textTheme.bodyMedium),
                  trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                ListTile(
                  onTap: () =>
                    launchUrl(privacyUrl),
                  //leading: SvgPicture.asset('assets/images/lock.svg'),
                  title: DefaultText(
                      text: 'Privacy Policy',
                      textStyle: Theme.of(context).textTheme.bodyMedium),
                  trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                ListTile(
                  onTap: () {
                    isGoogleEmail?  loginCubit.signOut() : loginCubit.logOut();
                  },
                  title: DefaultText(
                      text: 'Log Out',
                      textStyle: Theme.of(context).textTheme.bodyMedium),
                  trailing: Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
