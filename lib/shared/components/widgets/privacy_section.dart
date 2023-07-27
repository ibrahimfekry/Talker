import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';

class PrivacySection extends StatelessWidget {
  PrivacySection({Key? key,this.privacyName,this.privacyDetails,this.fontSize}) : super(key: key);

  String? privacyName;
  String? privacyDetails;
  double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          const CircleShape(),
          SizedBox(width: 5.w),
          DefaultText(text: '$privacyName',fontColor: blackColor,fontSize: fontSize,),
        ],),
        SizedBox(
          height: 8.h,
        ),
        DefaultText(
          text: '$privacyDetails',
          maxLines: 5,
          fontColor: blackColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
class CircleShape extends StatelessWidget {
  const CircleShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 7.w,
      decoration: BoxDecoration(
        color: blackColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
