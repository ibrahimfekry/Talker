import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SendBoxItem extends StatelessWidget{
  HexColor? containerColor;
  HexColor? textColor;
  double? fontSize;
  var sendFunction;
  var addTapFunction;
  var onTapTextForm;
  var onTapRecord;
  var onTapStop;
  TextEditingController? sendController;
  SendBoxItem({
    super.key,
    this.containerColor,
    this.textColor,
    this.fontSize,
    this.sendFunction,
    this.sendController,
    this.addTapFunction,
    this.onTapTextForm,
    this.onTapRecord,
    this.onTapStop
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor
      ),
      child: TextFormField(
        controller: sendController,
        onTap: onTapTextForm,
        style: TextStyle(
          color: textColor,
          decoration: TextDecoration.none,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: SizedBox(
              width: 42.w,
              child: Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 15.w, top: 11.h, bottom: 11.h, end: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/images/emoji.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      Positioned(
                          child: Container(
                            width: .5.w,
                            height: 20.h,
                            color: Colors.white,
                          )
                      ),
                    ],
                  )
              ),
            ),
            suffixIcon: SizedBox(
              width: 79.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTapRecord,
                    onDoubleTap: onTapStop,
                    child: SvgPicture.asset('assets/images/record.svg', width: 16.w, height: 16.h,)),
                  SizedBox(width: 9.w,),
                  GestureDetector(
                      onTap: addTapFunction,
                      child: SvgPicture.asset('assets/images/add_from_phone.svg', width: 16.w, height: 16.h,)),
                  SizedBox(width: 9.w,),
                  GestureDetector(
                      onTap: sendFunction,
                      child: SvgPicture.asset('assets/images/send.svg', width: 16.w, height: 16.h,)),
                  SizedBox(height: 9.w,),
                ],
              ),
            )),
      ),
    );
  }
}