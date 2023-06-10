import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../constants/colors.dart';

class DefaultText extends StatelessWidget {
  DefaultText({Key? key,this.text,this.textStyle,this.fontSize = 14,this.fontColor,this.fontWeight}) : super(key: key);
  String? text;
  FontWeight? fontWeight;
  double? fontSize;
  HexColor? fontColor = silverColor;
  dynamic textStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: textStyle ?? TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight
      ),
    );
  }
}