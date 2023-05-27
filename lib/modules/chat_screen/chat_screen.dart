import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/modules/chat_screen/record_message/sound_player.dart';
import 'package:talki/modules/chat_screen/record_message/sound_recorder.dart';
import '../../models/message_model.dart';
import '../../shared/components/widgets/bottom_sheet_item.dart';
import '../../shared/components/widgets/chat_bubble_item_receive.dart';
import '../../shared/components/widgets/chat_bubble_item_send.dart';
import '../../shared/components/widgets/text_form_field_send_item.dart';
import '../../shared/components/widgets/text_widget.dart';
import 'package:path/path.dart';

import '../../shared/constants/colors.dart';
import '../contact_screen/contact_screen.dart';
import 'chat_cubit.dart';
import 'chat_states.dart';


class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  ChatScreen({super.key, this.googleId, this.emailId, this.destinationId, this.chatId, this.firstName, this.lastName});
  String? emailId;
  dynamic googleId;
  dynamic destinationId;
  dynamic firstName;
  dynamic lastName;
  String? chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController sendController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  final scrollController = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheet = true;
  String? urlImage;
  String? urlCameraImage;
  String? urlFile;

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference messages = FirebaseFirestore.instance.collection('messages')
        .doc(widget.chatId).collection('channel');
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('messageTime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messageList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messageList.add(MessageModel.fromJson(snapshot.data?.docs[i]));
            }
            return BlocConsumer<ChatCubit, ChatStates>(
              listener: (context, state) {
                if(state is GetContactsSuccess){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactScreen(emailId: widget.emailId,googleId: widget.googleId,destinationId: widget.destinationId,)));
                }
              },
              builder: (context, state) {
                ChatCubit chatCubit = ChatCubit.get(context);
                if(chatCubit.phoneNumber != null) {
                  sendController.text = chatCubit.phoneNumber;
                }
                return ModalProgressHUD(
                  inAsyncCall: state is UploadImageLoading || state is UploadCameraImageLoading || state is UploadFileLoading ? true : false,
                  child: Scaffold(
                    key: scaffoldKey,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/icon_add.svg'),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultText(
                                  text: '${widget.firstName} ${widget.lastName}',
                                  fontSize: 13.sp,
                                  fontColor: whiteColor,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 8.h,
                                      width: 8.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: orangeColor),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    DefaultText(
                                      text: 'online',
                                      fontSize: 12.sp,
                                      fontColor: orangeColor,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: [
                        SvgPicture.asset(
                          'assets/images/videoCall.svg',
                          width: 15.w,
                          height: 13.h,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        SvgPicture.asset(
                          'assets/images/calling.svg',
                          width: 15.w,
                          height: 13.h,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        SvgPicture.asset(
                          'assets/images/menu.svg',
                          width: 15.w,
                          height: 13.h,
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
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
                                  return messageList[index].sendBy == widget.emailId || messageList[index].sendBy == widget.googleId
                                      ? ChatBubbleItemReceive(message: messageList[index].message,)
                                      : ChatBubbleItem(message: messageList[index].message,);
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 25.h,),
                              itemCount: snapshot.data!.docs.length,
                              controller: scrollController,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
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
                            sendController: sendController,
                            textColor: whiteColor,
                            onTapTextForm: (){},
                            sendFunction: () {
                              sendMessage(messages, chatCubit);
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
                                                        if (url != null) {
                                                          sendController.text = urlImage!;
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
                                                          sendController.text = urlCameraImage!;
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
                                                          sendController.text = urlFile!;
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

  void sendMessage(CollectionReference<Object?> messages, ChatCubit chatCubit) {
   if(sendController.text.isNotEmpty){
     messages.doc().set({
       'message': sendController.text,
       'messageTime': DateTime.now(),
       'desId' : widget.destinationId,
       'sendBy': widget.emailId != null ? widget.emailId.toString() : widget.googleId.toString(),
     }).then((value) {
       sendController.clear();
       chatCubit.phoneNumber = null;
       urlImage = null;
       urlCameraImage = null;
       urlFile = null ;
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
