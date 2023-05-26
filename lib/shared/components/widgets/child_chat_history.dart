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
    this.destinationId
  });
  String? emailId;
  dynamic googleId;
  dynamic destinationId;
  String? firstName;
  String? lastName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (emailId == null) {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      googleId: googleId,
                      destinationId: destinationId,)
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