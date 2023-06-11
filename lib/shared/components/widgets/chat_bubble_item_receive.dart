import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubit/chat_cubit/chat_cubit.dart';
import '../../cubit/chat_cubit/chat_states.dart';
import '../../../modules/pdf_screen/pdf_screen.dart';
import '../../constants/colors.dart';
import '../component/components.dart';

class ChatBubbleItemReceive extends StatefulWidget {
  final String? message;
  dynamic sendBy;

  ChatBubbleItemReceive({super.key, required this.message, this.sendBy});

  @override
  State<ChatBubbleItemReceive> createState() => _ChatBubbleItemReceiveState();
}

class _ChatBubbleItemReceiveState extends State<ChatBubbleItemReceive> {
  Widget? child;

  late AudioPlayer networkPlayer;
  late AudioCache cache;
  bool isPlayingNetwork = false;
  Duration currentPosition = const Duration();
  Duration musicLength = const Duration();

  lengthOfMusic() {
    networkPlayer.onAudioPositionChanged.listen((d) {
      setState(() {
        currentPosition = d;
      });
    });
    networkPlayer.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });
  }

  playNetworkAudio(url) async {
    await networkPlayer.play(url, isLocal: true);
  }

  stopNetworkAudio() {
    networkPlayer.pause();
  }

  seekTo(int sec) {
    networkPlayer.seek(Duration(seconds: sec));
  }

  @override
  void initState() {
    super.initState();
    networkPlayer = AudioPlayer();
    cache = AudioCache(fixedPlayer: networkPlayer);
    lengthOfMusic();
  }

  @override
  void dispose() {
    super.dispose();
    networkPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    typeOfMessage(message: widget.message, sendBy: widget.sendBy);
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) { },
      builder: (context, state) {
        ChatCubit chatCubit = ChatCubit.get(context);
        return GestureDetector(
          onTap: (){ },
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    topLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  color: orangeColor),
              child: child!,
            ),
          ),
        );
      },
    );
  }

  typeOfMessage({message, sendBy}){
    if (message.contains('jpg') ||
        message.contains('jpeg') ||
        message.contains('png')) {
      child = childImage(urlImage: message, sendBy: sendBy);
    } else if (message.contains('pdf')) {
      child = childPdf(context: context, urlPdf: message, sendBy: sendBy);
    } else if (message.contains('docx')) {
      child = childWord();
    } else if (message.contains('xlsx')) {
      child = childExcel(sendBy: sendBy);
    } else if (message.contains('mp3')) {
      child = childMp3(
        context: context,
        sendBy: sendBy,
        onTap: (){
          if (isPlayingNetwork) {
            setState(() {
              isPlayingNetwork = false;
            });
            stopNetworkAudio();
          } else {
            setState(() {
              isPlayingNetwork = true;
            });
            playNetworkAudio(message);
          }
        },
        icon: isPlayingNetwork && (currentPosition.inSeconds.toDouble() !=  musicLength.inSeconds.toDouble()) ? const Icon(Icons.pause) : const Icon(Icons.play_arrow) ,
        value: currentPosition.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (val) {
          seekTo(val.toInt());
        },
      );
    } else if (message.contains('txt')){
      child = childTxt(context: context, sendBy: sendBy, urlTxt: message);
    } else {
      child = defaultMessage(message: message, sendBy: sendBy, context: context);
    }
  }
}
