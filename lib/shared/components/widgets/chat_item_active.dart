import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/constants.dart';
import '../../../modules/chat_screen/chat_screen.dart';
import '../../constants/colors.dart';

class ChatActiveItem extends StatelessWidget{
  String? firstName;
  String? lastName;
  String? status;
  String? url;
  String? emailId;
  dynamic googleId;
  dynamic destinationId;
  dynamic user1;
  dynamic user2;
  bool isGroup = false;

  ChatActiveItem({super.key,
    this.firstName,
    this.lastName,
    this.status,
    this.url,
    this.emailId,
    this.googleId,
    this.destinationId,
    this.user1,
    this.user2,
    this.isGroup = false
  });

  String chatRoomId ({user1, user2}){
    if(user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 50.w,
      child: GestureDetector(
        onTap: (){
          if (isGroup == false){
            String roomID = chatRoomId(user1: user1, user2: user2);
            if (emailId == null) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    googleId: googleId,
                    destinationId: destinationId,
                    firstName: firstName,
                    lastName: lastName,
                    chatId: roomID,
                    status: status,
                    url: url,
                  )
              )
              );
            } else {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        emailId: emailId,
                        destinationId: destinationId,
                        firstName: firstName,
                        lastName: lastName,
                        chatId: roomID,
                        status: status,
                        url: url,
                      )
                  )
              );
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  //SvgPicture.asset('assets/images/icon_green.svg')
                  status == "Online" ? SvgPicture.asset('assets/images/icon_green.svg') : Container(),
                ],
              ),
            ),
            SizedBox(height: 5.h,),
            DefaultText(text: '$firstName $lastName',
              textStyle: Theme.of(context).textTheme.bodySmall,),
          ],
        ),
      ),
    );
  }
}