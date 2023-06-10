import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import '../../constants/colors.dart';

class ChatActiveItem extends StatelessWidget{
  String? name;
  String? status;
  String? url;
  ChatActiveItem({super.key, this.name, this.status, this.url});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white ,
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              url == null ? SvgPicture.asset('assets/images/icon_avatar.svg',) : Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(image: NetworkImage('$url'),)
              ),
              SvgPicture.asset('assets/images/icon_green.svg')
              //status == "Online" ? SvgPicture.asset('assets/images/icon_green.svg') : Container(),
            ],
          ),
        ),
        SizedBox(height: 5.h,),
        DefaultText(text: name ,
          textStyle: Theme.of(context).textTheme.bodySmall,),
      ],
    );
  }
}