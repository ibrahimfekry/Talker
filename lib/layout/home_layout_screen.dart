import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../modules/add_screen/add_screen.dart';
import '../modules/calls_screen/calls_screen.dart';
import '../modules/chats_screen_history/chats_screen_history.dart';
import '../modules/groups_screen/groups_screen.dart';
import '../modules/menu_screen/menu_screen.dart';
import '../shared/components/widgets/bottom_bar_button.dart';
import '../shared/components/widgets/text_widget.dart';
import '../shared/constants/colors.dart';
import 'layout_cubit.dart';
import 'layout_states.dart';

class HomeLayoutScreen extends StatefulWidget {
  HomeLayoutScreen({Key? key, this.emailId, this.googleId}) : super(key: key);
  static String id = 'HomeLayout';
  String? emailId;
  dynamic googleId;
  @override
  State<HomeLayoutScreen> createState() => _HomeLayoutScreenState();
}

class _HomeLayoutScreenState extends State<HomeLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    print('alaagoogle = ${widget.googleId}');
    print('alaaemail = ${widget.emailId}');
    LayoutCubit layoutCubit = LayoutCubit.get(context);
    List screens = [
      ChatsScreenHistory(emailId: widget.emailId, googleId: widget.googleId,),
      CallsScreen(),
      AddScreen(),
      GroupsScreen(),
      MenuScreen()
    ];
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: CurvedNavigationBar(
            height: 56.h,
            color: scaffoldColorDark,
            backgroundColor: orangeColor,
            animationCurve: Curves.easeInOut,
            onTap: (index) {
              layoutCubit.changeIndex(index);
            },
            items: <Widget>[
              BottomBarButton(
                buttonTxt: 'Chats',
                iconUrl: 'assets/images/icon_chat.svg',
                showTxt: true,
              ),
              BottomBarButton(
                buttonTxt: 'Calls',
                iconUrl: 'assets/images/icon_calls.svg',
                showTxt: true,
              ),
              BottomBarButton(
                buttonTxt: 'Add',
                iconUrl: 'assets/images/icon_add.svg',
                showTxt: false,
              ),
              BottomBarButton(
                buttonTxt: 'Groups',
                iconUrl: 'assets/images/icon_groups.svg',
                showTxt: true,
              ),
              BottomBarButton(
                buttonTxt: 'Menu',
                iconUrl: 'assets/images/icon_menu.svg',
                showTxt: true,
              ),
            ],
          ),
          body: screens[layoutCubit.pageIndex],
        );
      },
    );
  }
}
