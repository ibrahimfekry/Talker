import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import '../../constants/colors.dart';

class ChatActiveItem extends StatelessWidget{
  String? name;
  String? status;
  ChatActiveItem({super.key, this.name, this.status});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white ,
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              SvgPicture.asset('assets/images/icon_avatar.svg',),
              SvgPicture.asset('assets/images/icon_green.svg')
              //status == "Online" ? SvgPicture.asset('assets/images/icon_green.svg') : Container(),
            ],
          ),
        ),
        SizedBox(height: 5.h,),
        DefaultText(text: name ,fontColor: whiteColor,fontSize: 10.sp,fontWeight: FontWeight.w300,),
      ],
    );
  }
}