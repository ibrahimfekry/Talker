import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/shared/cubit/chat_cubit/chat_cubit.dart';
import 'package:talki/shared/cubit/chat_cubit/chat_states.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';

import '../../shared/components/widgets/bottom_sheet_item.dart';
import '../../shared/components/widgets/chat_bubble_item_receive.dart';
import '../../shared/components/widgets/chat_bubble_item_send.dart';
import '../../shared/components/widgets/text_form_field_send_item.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../chat_screen/record_message/sound_player.dart';
import '../chat_screen/record_message/sound_recorder.dart';
import '../contact_screen/contact_screen.dart';
import 'group_info.dart';

class GroupChatRoom extends StatefulWidget {
  GroupChatRoom({Key? key, required this.groupChatId, required this.groupName, this.isGroupChat = false})
      : super(key: key);
  final String groupChatId, groupName;
  bool? isGroupChat;

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {

  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final scrollController = ScrollController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  bool isBottomSheet = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String? urlImage;
  String? urlCameraImage;
  String? urlFile;

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPressed() async {
      if(widget.isGroupChat == true){
        widget.isGroupChat = false;
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
      }
      return true;
    }
    final size = MediaQuery.of(context).size;
    ChatCubit chatCubit = ChatCubit.get(context);
    return StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('groups').doc(widget.groupChatId).collection('chats').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocConsumer<ChatCubit, ChatStates>(
              listener: (context, state) {
                if(state is GetContactsSuccess){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactScreen(
                    isChatUserScreen: false,
                    groupChatId: widget.groupChatId,
                    groupName: widget.groupName,
                  )));
                }
              },
              builder: (context, state) {
                if(chatCubit.phoneNumber != null) {
                  messageController.text = chatCubit.phoneNumber;
                }
                return ModalProgressHUD(
                  inAsyncCall: state is UploadImageLoading || state is UploadCameraImageLoading || state is UploadFileLoading ? true : false,
                  child: WillPopScope(
                    onWillPop: onBackPressed,
                    child: Scaffold(
                      key: scaffoldKey,
                      appBar: AppBar(
                        leading: const Icon(Icons.group, color: Colors.white,),
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: EdgeInsetsDirectional.only(start: 10.w),
                          child: DefaultText(
                            text: widget.groupName,
                            fontSize: 20.sp,
                          ),
                        ),
                        actions: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GroupInfo(
                                            groupName: widget.groupName,
                                            groupId: widget.groupChatId,
                                          ))),
                              icon: const Icon(Icons.more_vert)),
                          SizedBox(width: 10.w,)
                        ],
                      ),
                      body: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                reverse: true,
                                controller: scrollController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> chatMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                  return chatMap['sendBy'] == auth.currentUser!.email
                                      ? ChatBubbleItemReceive(message: chatMap['message'], sendBy: chatMap['sendBy'] , )
                                      : ChatBubbleItem(message: chatMap['message'], sendBy: chatMap['sendBy'],);
                                  // return messageTile(size, chatMap);
                                },
                                separatorBuilder: (context, index) => SizedBox(height: 10.h,
                                ),
                              ),
                            ),
                            SendBoxItem(
                              containerColor: HexColor('#1C1C1C'),
                              onTapRecord: () async {
                                await recorder.toogleRecording();
                                setState((){});
                              },
                              onTapStop: () async {
                                await player.tooglePlaying(whenFinished: ()=> setState((){}));
                                setState((){});
                              },
                              fontSize: 13.sp,
                              sendController: messageController,
                              textColor: whiteColor,
                              onTapTextForm: (){},
                              sendFunction: () {
                                onSendMessage(
                                  messageText: messageController.text,
                                  groupChatId: widget.groupChatId,
                                  sendBy: auth.currentUser!.email,
                                  chatCubit: chatCubit
                                );
                              },
                              addTapFunction: () {
                                if (isBottomSheet) {
                                  scaffoldKey.currentState?.showBottomSheet((context) {
                                    return BlocConsumer <ChatCubit, ChatStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        return Container(
                                          color: HexColor('#000000'),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w , vertical: 15.w),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:  BottomSheetItem(
                                                        backgroundUrl:'assets/images/backgroundGallery.svg',
                                                        imageUrl: 'assets/images/white.svg',
                                                        imageUrl2: 'assets/images/gallery.svg',
                                                        onTap: () async {
                                                          Navigator.pop(context);
                                                          await chatCubit.uploadImage();
                                                          urlImage = chatCubit.url;
                                                          if (urlImage != null) {
                                                            messageController.text = urlImage!;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: BottomSheetItem(
                                                        backgroundUrl:'assets/images/cameraBackground.svg',
                                                        imageUrl: 'assets/images/camera.svg',
                                                        onTap: () async {
                                                          Navigator.pop(context);
                                                          await chatCubit.uploadImageCamera();
                                                          urlCameraImage = chatCubit.urlCamera;
                                                          if(urlCameraImage != null){
                                                            messageController.text = urlCameraImage!;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: BottomSheetItem(
                                                        backgroundUrl:'assets/images/documentBackground.svg',
                                                        imageUrl: 'assets/images/document.svg',
                                                        onTap: () async {
                                                          Navigator.pop(context);
                                                          await chatCubit.pickFile();
                                                          urlFile = chatCubit.urlFile;
                                                          if(urlFile != null){
                                                            messageController.text = urlFile!;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15.h,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: BottomSheetItem(
                                                        backgroundUrl:'assets/images/contactBackground.svg',
                                                        imageUrl: 'assets/images/contact.svg',
                                                        onTap: ()  {
                                                          Navigator.pop(context);
                                                          chatCubit.getContactPermission();
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(child: Container()),
                                                    Expanded(child: Container()),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).closed.then((value){
                                    isBottomSheet = true;
                                  });
                                  isBottomSheet = false;
                                } else {
                                  Navigator.pop(context);
                                  isBottomSheet = true;
                                }
                              },
                            )
                          ],
                        ),
                      ),
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

  // Send Message for chat group
  void onSendMessage({required String messageText, dynamic sendBy, dynamic groupChatId, required ChatCubit chatCubit}) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    if (messageText.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": sendBy,
        "message": messageText,
        "type": "text",
        "time": DateTime.now(),
      };
      await fireStore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData).then((value) {
            messageController.clear();
            chatCubit.phoneNumber = null;
            urlImage = null;
            urlCameraImage = null;
            urlFile = null ;
        scrollController.animateTo(0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn);
      }).catchError((error) {
        if (kDebugMode) {print('Error send message = $error');}
      });
    }
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
