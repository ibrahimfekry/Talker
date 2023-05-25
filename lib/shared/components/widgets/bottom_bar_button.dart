import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';

class BottomBarButton extends StatelessWidget {
  String iconUrl;
  String buttonTxt;
  bool showTxt;

  BottomBarButton(
      {Key? key,
        required this.iconUrl,
        required this.buttonTxt,
        required this.showTxt})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 9.h,start:3.w,end: 3.w,bottom: 2.h
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconUrl,
            ),
            SizedBox(
              height: 8.h,
            ),
            Visibility(
              visible: showTxt,
              child: Text(
                buttonTxt,
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
