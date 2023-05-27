import 'package:flutter/material.dart';

import '../../../modules/chat_screen/chat_screen.dart';
import 'chat_screen_history_item.dart';

class ItemChatHistory extends StatelessWidget{
  ItemChatHistory({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    this.googleId,
    this.destinationId,
    this.user1,
    this.user2
  });
  String? emailId;
  dynamic googleId;
  dynamic destinationId;
  String? firstName;
  String? lastName;
  dynamic user1;
  dynamic user2;

  String chatRoomId ({user1, user2}){
    if(user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          String roomID = chatRoomId(user1: user1, user2: user2);
          if (emailId == null) {
            Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      googleId: googleId,
                      destinationId: destinationId,
                      firstName: firstName,
                      lastName: lastName,
                      chatId: roomID,
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
                    )
                )
            );
          }
        },
        child: ChatScreenHistoryItem(
          name: '$firstName $lastName',
        )
    );
  }
}