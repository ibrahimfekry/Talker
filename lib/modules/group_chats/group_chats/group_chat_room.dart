import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';

import '../../../shared/components/widgets/text_widget.dart';
import '../../../shared/cubit/login_register_cubit/login_cubit.dart';
import 'group_info.dart';

class GroupChatRoom extends StatelessWidget {
  GroupChatRoom({Key? key, required this.groupChatId, required this.groupName})
      : super(key: key);

  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String groupChatId, groupName;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is SendMessageGroupSuccess) {
          messageController.clear();
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
            stream: fireStore.collection('groups').doc(groupChatId).collection('chats').orderBy('time').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BlocConsumer<LoginCubit, LoginStates>(
                  listener: (context, state) {
                    if (state is SendMessageGroupSuccess) {
                      scrollController.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn);
                    }
                  },
                  builder: (context, state) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: const Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: EdgeInsetsDirectional.only(start: 10.w),
                          child: DefaultText(
                            text: groupName,
                            fontSize: 20.sp,
                          ),
                        ),
                        actions: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GroupInfo(
                                            groupName: groupName,
                                            groupId: groupChatId,
                                          ))),
                              icon: const Icon(Icons.more_vert)),
                          SizedBox(
                            width: 10.w,
                          )
                        ],
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              reverse: true,
                              controller: scrollController,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> chatMap =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                return messageTile(size, chatMap);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10.h,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height / 12,
                                width: size.width / 1.3,
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    loginCubit.onSendMessage(
                                      messageText: messageController.text,
                                      groupChatId: groupChatId,
                                      sendBy: auth.currentUser!.email,
                                    );
                                  },
                                  icon: const Icon(Icons.send)),
                            ],
                          ),
                        ],
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
      },
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == auth.currentUser!.email
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  //Sender

                  Text(
                    "${chatMap['sendBy']}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
