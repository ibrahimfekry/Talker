import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'text_widget.dart';
import '../../constants/colors.dart';
import '../../../modules/chat_screen/chat_screen.dart';

class ChatScreenHistoryItem extends StatelessWidget {

  String? name;
  String? time;

  ChatScreenHistoryItem({super.key, this.name, this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white ,
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              SvgPicture.asset('assets/images/icon_avatar.svg',),
              SvgPicture.asset('assets/images/icon_green.svg'),
            ],
          ),
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(text: name,fontColor: whiteColor,fontSize: 10.sp,fontWeight: FontWeight.w300,),
              // SizedBox(height: 3.h,),
              // Container(
              //     width: 225.w,height: 23.h,
              //     child: DefaultText(text:'Hello there! .',fontColor: whiteColor,fontSize: 10.sp,fontWeight: FontWeight.w300,)),
            ],
          ),
        ),
        // Column(
        //   children: [
        //     DefaultText(text:time,fontColor: whiteColor,fontSize: 10.sp,fontWeight: FontWeight.w300,),
        //     Container(
        //         width:15.w,height:15.h,
        //         color: orangeColor,
        //         child: Center(child: Text('8'))),
        //   ],
        // ),
      ],
    );
  }
}