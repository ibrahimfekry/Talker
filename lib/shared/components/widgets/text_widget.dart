import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../constants/colors.dart';

class DefaultText extends StatelessWidget {
  DefaultText(
      {Key? key,
      this.text,
      this.textStyle,
      this.fontSize = 14,
      this.fontColor,
      this.fontWeight,
      this.maxLines})
      : super(key: key);
  String? text;
  FontWeight? fontWeight;
  double? fontSize;
  HexColor? fontColor = silverColor;
  dynamic textStyle;
  int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: textStyle ??
          TextStyle(
            fontSize: fontSize,
            color: fontColor,
            fontWeight: fontWeight,
          ),
    );
  }
}
