import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';

import '../../models/users_model.dart';
import '../../shared/components/widgets/add_member_Item.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../edit_profile/edit_profile.dart';
import '../forget_password_screen/forget_password_screen.dart';

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
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: double.infinity,
          alignment: Alignment.topRight,
          child: Drawer(
            backgroundColor: scaffoldColorDark,
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
                    fontColor: whiteColor,
                    fontSize: 14.sp,
                  ),
                  accountEmail: DefaultText(
                    text: FirebaseAuth.instance.currentUser?.email,
                    fontColor: whiteColor,
                    fontSize: 12.sp,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> EditProfileScreen(
                          firstName: "${loginCubit.profileData['firstName']}",
                          lastName: "${loginCubit.profileData['lastName']}",
                          date: loginCubit.profileData['date'],
                        )));
                  },
                  //leading: SvgPicture.asset('assets/images/profile_edit.svg'),
                  title: DefaultText(
                      text: 'Edit profile information',
                      fontWeight: FontWeight.w400,
                      fontColor: whiteColor,
                      fontSize: 14),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: whiteColor,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  //leading: SvgPicture.asset('assets/images/dark-mode.svg'),
                  title: DefaultText(
                      text: 'Dark Mode',
                      fontWeight: FontWeight.w400,
                      fontColor: whiteColor,
                      fontSize: 14),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),);
                  },
                  //leading: SvgPicture.asset('assets/images/lock.svg'),
                  title: DefaultText(
                      text: 'Change Password',
                      fontWeight: FontWeight.w400,
                      fontColor: whiteColor,
                      fontSize: 14),
                  trailing: Icon(Icons.chevron_right, color: whiteColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
