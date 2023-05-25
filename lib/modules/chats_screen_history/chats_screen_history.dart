import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/modules/login_Screen/login_cubit.dart';
import 'package:talki/modules/login_Screen/login_states.dart';
import '../../models/users_model.dart';
import '../../shared/components/widgets/chat_item_active.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/components/widgets/chat_screen_history_item.dart';
import '../chat_screen/chat_screen.dart';

class ChatsScreenHistory extends StatefulWidget {
  ChatsScreenHistory(
      {Key? key, this.googleId, this.emailId, this.destinationId})
      : super(key: key);
  static String id = 'ChatScreenHistory';
  String? emailId;
  dynamic googleId;
  dynamic destinationId;

  @override
  State<ChatsScreenHistory> createState() => _ChatsScreenHistoryState();
}

class _ChatsScreenHistoryState extends State<ChatsScreenHistory> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModelRegister> userList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              userList.add(UserModelRegister.fromJson(snapshot.data?.docs[i]));
            }
            return BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state) {},
              builder: (context, state) {
                LoginCubit loginCubit = LoginCubit.get(context);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => ChatActiveItem(name: '${userList[index].firstName} ${userList[index].lastName}'),
                              separatorBuilder: (context, index) => SizedBox(width: 11.w,),
                              itemCount: snapshot.data!.docs.length),
                        ),
                        SizedBox(height: 13.h,),
                        DefaultTextField(
                          color: whiteColor,
                          suffix: GestureDetector(
                              onTap: (){
                                loginCubit.searchUser(searchController.text, userList);
                              },
                              child: Icon(Icons.search, color: orangeColor,)),
                          prefix: const SizedBox(),
                          hintText: 'Search for contents',
                          controller: searchController,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        DefaultText(
                            text: 'Your Messages',
                            fontColor: whiteColor,
                            fontWeight: FontWeight.w800),
                        SizedBox(
                          height: 28.h,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: userList.length,
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  if (widget.emailId == null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(googleId: widget.googleId, destinationId: userList[index].emailAddress,)));
                                  } else {
                                    String chatId = loginCubit.chatRoomId(
                                        user1 : loginCubit.registerAuth.currentUser?.displayName,
                                        user2: userList[index].firstName);
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              emailId: widget.emailId,
                                              destinationId: userList[index].emailAddress,
                                              chatId: chatId,
                                              firstName:userList[index].firstName,
                                              lastName: userList[index].lastName,
                                            )
                                        )
                                    );
                                  }
                                },
                                child: ChatScreenHistoryItem( name: '${userList[index].firstName} ${userList[index].lastName}',)),
                            separatorBuilder: (context, index) => SizedBox(height: 13.h,),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
