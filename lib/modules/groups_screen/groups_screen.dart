import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';
import '../GroupChatRoom/GroupChatRoom.dart';

class GroupsScreen extends StatelessWidget{
  static String id = 'GroupsScreen';
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatRoom(index: index,)));
          },
          leading: Icon(Icons.group, color: whiteColor,),
          title: DefaultText(
            text: 'Group ${index+1}',
            fontColor: whiteColor,
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 5.h,),
        itemCount: 5
    );
  }
}
