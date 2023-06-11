import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:talki/modules/txt_screen/txt_screen.dart';

import '../../../modules/pdf_screen/pdf_screen.dart';
import '../../constants/colors.dart';
import '../widgets/text_widget.dart';

void defaultSnackBar({required BuildContext context , required String text , required Color color }) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
  ));
}

 Widget childImage({urlImage, sendBy, context}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(sendBy != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                  text: '$sendBy',
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h,),
                Container(height: 1.h, color: scaffoldColorDark,),
                SizedBox(height: 4.h,),
              ],
            ),
          Image.network(urlImage)
        ],
      ),
    );
}

Widget childPdf({urlPdf, context, sendBy}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PdfScreen.id, arguments: urlPdf);
            },
            child: DefaultText(
              text: 'file.pdf',
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )),
      ],
    ),
  );
}

Widget childTxt({urlTxt, context, sendBy}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        GestureDetector(
            onTap: () {
             //Navigator.push(context, MaterialPageRoute(builder: (context) => TxtScreen(message: urlTxt,)));
            },
            child: DefaultText(
              text: 'TXTFile.txt',
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )
        ),
      ],
    ),
  );
}

Widget childWord ({sendBy, context}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        GestureDetector(
            onTap: () {},
            child: DefaultText(
              text: 'file.docx',
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )),
      ],
    ),
  );
}

Widget childExcel ({sendBy, context}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context, WebViewScreen.id, arguments: message);
            },
            child: DefaultText(
              text: 'file.xlsx',
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )),
      ],
    ),
  );
}

Widget childMp3 ({
  required dynamic onTap,
  required Icon icon,
  context,
  required double value,
  required double max,
  dynamic onChanged,
  sendBy
}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                icon,
                SizedBox(width: MediaQuery.of(context).size.width / 2.6,
                  child: Slider(
                    value: value,
                    max: max,
                    onChanged: onChanged,
                    activeColor: scaffoldColorDark,
                    inactiveColor: Colors.black.withOpacity(.3),
                  ),
                )
              ],
            )
        ),
      ],
    ),
  );
}

Widget defaultMessage({message, sendBy, context}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sendBy != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: '$sendBy',
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              Container(height: 1.h, color: scaffoldColorDark,),
              SizedBox(height: 4.h,),
            ],
          ),
        DefaultText(
          text: "$message",
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}



