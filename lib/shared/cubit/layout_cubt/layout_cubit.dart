import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../modules/add_screen/add_screen.dart';
import '../../../modules/calls_screen/calls_screen.dart';
import '../../../modules/chats_screen_history/chats_screen_history.dart';
import '../../../modules/groups_screen/groups_screen.dart';
import '../../../modules/menu_screen/menu_screen.dart';
import '../../components/widgets/text_widget.dart';
import '../../constants/colors.dart';
import 'package:flutter/material.dart';

import 'layout_states.dart';

class LayoutCubit extends Cubit <LayoutStates>{
  LayoutCubit() : super (InitialHomeLayoutStates());
  static LayoutCubit get (context) => BlocProvider.of(context);

  int pageIndex =0;

  changeIndex(int currentIndex){
    pageIndex = currentIndex;
    emit(ChangeBottomIndex());
  }

  List appBarItems =[
    DefaultText(
        text: 'Your Friends',
        fontSize: 14.sp,
        fontColor: whiteColor,
        fontWeight: FontWeight.w800
    ),

  ];
}

