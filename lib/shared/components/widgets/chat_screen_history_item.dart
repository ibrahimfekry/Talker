import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'text_widget.dart';
import '../../constants/colors.dart';
import '../../../modules/chat_screen/chat_screen.dart';

class ChatScreenHistoryItem extends StatelessWidget {

  String? name;
  String? time;
  String? status;
  String? url;

  ChatScreenHistoryItem({super.key, this.name, this.time, this.status, this.url});

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
              url == null ? SvgPicture.asset('assets/images/icon_avatar.svg',) : Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(image: NetworkImage('$url'),)
              ),
              status == "Offline" ? Container(
                width: 11.w,
                height: 11.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
              ) : SvgPicture.asset('assets/images/icon_green.svg')
            ],
          ),
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(text: name,fontColor: whiteColor,fontSize: 10.sp,fontWeight: FontWeight.w300,),
            ],
          ),
        ),
      ],
    );
  }
}