import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/chats_screen_history/chats_screen_history.dart';
import '../modules/group_chats/group_chat_screen.dart';
import '../modules/menu_screen/menu_screen.dart';
import '../shared/components/widgets/bottom_bar_button.dart';
import '../shared/components/widgets/text_widget.dart';
import '../shared/constants/colors.dart';
import '../shared/cubit/layout_cubt/layout_cubit.dart';
import '../shared/cubit/layout_cubt/layout_states.dart';

class HomeLayoutScreen extends StatefulWidget {

  HomeLayoutScreen({Key? key, this.emailId, this.googleId,}) : super(key: key);

  //////////////////////// variables
  static String id = 'HomeLayout';
  String? emailId;
  dynamic googleId;

  @override
  State<HomeLayoutScreen> createState() => _HomeLayoutScreenState();
}

class _HomeLayoutScreenState extends State<HomeLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = LayoutCubit.get(context);
    List screens = [
      ChatsScreenHistory(emailId: widget.emailId, googleId: widget.googleId,),
      GroupScreen(),
      MenuScreen()
    ];

    List appbarTitles = [
      DefaultText(text: 'Chats', textStyle: Theme.of(context).appBarTheme.titleTextStyle,),
      DefaultText(text: 'Groups', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      DefaultText(text: 'Menu', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
    ];
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: appbarTitles[layoutCubit.pageIndex],
            actions: [
              IconButton(
                  onPressed: (){
                    layoutCubit.changeAppMode();
                  },
                  icon: const Icon(Icons.brightness_4_outlined)
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: CurvedNavigationBar(
            height: 56.h,
            index: layoutCubit.pageIndex,
            color: scaffoldColorDark,
            backgroundColor: orangeColor,
            animationCurve: Curves.easeInOut,
            onTap: (index) { layoutCubit.changeIndex(index);},
            items: <Widget>[
              BottomBarButton(
                buttonTxt: 'Chats',
                iconUrl: 'assets/images/icon_chat.svg',
                showTxt: true,
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


