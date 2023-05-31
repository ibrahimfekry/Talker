import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';

class ButtonCreateDeleteGroup extends StatelessWidget{

  dynamic fontColor;
  dynamic backgroundColor;
  dynamic onTap;
  String? text;

  ButtonCreateDeleteGroup({super.key, this.fontColor, this.text, this.onTap, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height : 40.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: GestureDetector(
            onTap: onTap,
            child: DefaultText(
              text: text,
              fontColor: fontColor,
              fontSize: 14.sp,
            )
        ),
      ),
    );
  }
}