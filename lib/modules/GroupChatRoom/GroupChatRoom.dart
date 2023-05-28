import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';

import '../../shared/components/widgets/bottom_sheet_item.dart';
import '../../shared/components/widgets/text_form_field_send_item.dart';
import '../../shared/cubit/chat_cubit/chat_cubit.dart';
import '../../shared/cubit/chat_cubit/chat_states.dart';

class GroupChatRoom extends StatefulWidget{
  String? emailId;
  dynamic googleId;
  int? index;
  GroupChatRoom({super.key, this.index});

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  TextEditingController chatMessage = TextEditingController();
  final scrollController = ScrollController();
  bool isBottomSheet = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: DefaultText(
          text: 'Group ${widget.index!+1}',
          fontSize: 16.sp,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: whiteColor,)),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 15.w, top: 29.h, end: 15.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true,
                itemBuilder: (context, index){

                },
                separatorBuilder: (context, index) => SizedBox(height: 25.h,),
                itemCount: 2,
                controller: scrollController,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            SendBoxItem(
              containerColor: HexColor('#1C1C1C'),
              onTapRecord: (){},
              onTapStop: (){},
              fontSize: 13.sp,
              sendController: chatMessage,
              textColor: whiteColor,
              onTapTextForm: (){},
              sendFunction: () {

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
                                        onTap: (){},
                                      ),
                                    ),
                                    Expanded(
                                      child: BottomSheetItem(
                                        backgroundUrl:'assets/images/cameraBackground.svg',
                                        imageUrl: 'assets/images/camera.svg',
                                        onTap: () {},
                                      ),
                                    ),
                                    Expanded(
                                      child: BottomSheetItem(
                                        backgroundUrl:'assets/images/documentBackground.svg',
                                        imageUrl: 'assets/images/document.svg',
                                        onTap: () {},
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
                                        onTap: (){},
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
    );
  }

  void sendMessage(CollectionReference<Object?> messagesGroup, ChatCubit chatCubit) {
    if(chatMessage.text.isNotEmpty){
      messagesGroup.doc().set({
        'message': chatMessage.text,
        'messageTime': DateTime.now(),
        //'desId' : widget.destinationId,
        'sendBy': FirebaseAuth.instance.currentUser?.email != null ? FirebaseAuth.instance.currentUser?.email.toString() : widget.googleId.toString(),
      }).then((value) {
        chatMessage.clear();
        chatCubit.phoneNumber = null;
        // urlImage = null;
        // urlCameraImage = null;
        // urlFile = null ;
        scrollController.animateTo(
            0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn);
      });
    }else{
      if (kDebugMode){print('Enter some Text');}
    }
  }
}