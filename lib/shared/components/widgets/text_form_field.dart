import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';

class DefaultTextField extends StatelessWidget {
  DefaultTextField({
    Key? key,
    this.prefix,
    this.hintText,
    this.textInputType,
    this.height,
    this.suffix,
    this.color,
    this.controller,
    this.borderRadius,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.obscureText = false
  }) : super(key: key);

  double? height;
  Widget? prefix;
  Widget? suffix;
  TextInputType? textInputType;
  String? hintText;
  double? width;
  Color? color ;
  TextEditingController? controller;
  var onSubmitted;
  var onTap;
  double? borderRadius;
  bool obscureText;
  dynamic validator;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          onTap: onTap,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText,
          style: TextStyle(color: silverColor,),
          decoration: InputDecoration(
            prefix: SizedBox(width: 15.w,),
            suffixIcon: suffix,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w700, color: silverColor),
          ),
        )
    );
  }
}