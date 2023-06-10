import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';

class AddMemberItem extends StatelessWidget{
  dynamic iconColor;
  IconData? icon;
  String? firstName;
  String? emailAddress;
  dynamic onPress;
  String? url;

  AddMemberItem({super.key, this.iconColor , this.firstName, this.emailAddress, this.onPress, this.icon, this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: url != null ? Image(image: NetworkImage('$url'),) : const Icon(Icons.person),
          ),
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: firstName,
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h,),
              DefaultText(
                text: emailAddress,
                textStyle: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w,),
        IconButton(
          icon: Icon(icon,
            color: iconColor
          ),
          onPressed: onPress,
        ),
      ],
    );
  }
}