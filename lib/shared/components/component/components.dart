import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../modules/pdf_screen/pdf_screen.dart';
import '../../constants/colors.dart';
import '../widgets/text_widget.dart';

void defaultSnackBar({required BuildContext context , required String text , required Color color }) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    ),
    backgroundColor: color,
  ));
}

 Widget childImage({urlImage}){
    return Image.network(urlImage);
}

Widget childPdf({urlPdf, context}){
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PdfScreen.id, arguments: urlPdf);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
        child: DefaultText(
          text: 'file.pdf',
          fontColor: whiteColor,
        ),
      ));
}

Widget childWord (){
  return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
        child: DefaultText(
          text: 'file.docx',
          fontColor: whiteColor,
        ),
      ));
}

Widget childExcel (){
  return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, WebViewScreen.id, arguments: message);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
        child: DefaultText(
          text: 'file.xlsx',
          fontColor: whiteColor,
        ),
      ));
}

Widget childMp3 ({
  required dynamic onTap,
  required Icon icon,
  context,
  required double value,
  required double max,
  dynamic onChanged
}){
  return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          SizedBox(width: MediaQuery.of(context).size.width / 2.4,
            child: Slider(
              value: value,
              max: max,
              onChanged: onChanged,
              activeColor: orangeColor,
              inactiveColor: Colors.orange.withOpacity(.3),
            ),
          )
        ],
      ));
}

Widget defaultMessage({message}){
  return Padding(
    padding: EdgeInsetsDirectional.only(
        start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
    child: DefaultText(
      text: "$message",
      fontColor: whiteColor,
      fontSize: 13.sp,
    ),
  );
}



