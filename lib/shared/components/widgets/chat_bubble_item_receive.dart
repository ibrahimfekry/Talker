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

class ChatBubbleItemReceive extends StatefulWidget {
  final String? message;

  ChatBubbleItemReceive({super.key, required this.message});

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
    // TODO: implement initState
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
    if (widget.message!.contains('jpg') ||
        widget.message!.contains('jpeg') ||
        widget.message!.contains('png')) {
      child = Image.network(widget.message!);
    } else if (widget.message!.contains('pdf')) {
      child = GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PdfScreen.id,
                arguments: widget.message);
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
            child: DefaultText(
              text: 'PDF File',
              fontColor: whiteColor,
            ),
          ));
    } else if (widget.message!.contains('docx')) {
      child = GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, WebViewScreen.id, arguments: message);
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
            child: DefaultText(
              text: 'file.docx',
              fontColor: whiteColor,
            ),
          ));
    } else if (widget.message!.contains('xlsx')) {
      child = GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, WebViewScreen.id, arguments: message);
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
            child: DefaultText(
              text: 'file.xlsx',
              fontColor: whiteColor,
            ),
          ));
    } else if (widget.message!.contains('mp3')) {
      child = GestureDetector(
          onTap: () {
            if (isPlayingNetwork) {
              setState(() {
                isPlayingNetwork = false;
              });
              stopNetworkAudio();
            } else {
              setState(() {
                isPlayingNetwork = true;
              });
              playNetworkAudio(widget.message);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isPlayingNetwork
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  max: musicLength.inSeconds.toDouble(),
                  onChanged: (val) {
                    seekTo(val.toInt());
                  },
                  activeColor: silverColor,
                  inactiveColor: Colors.grey.withOpacity(.3),
                ),
              )
            ],
          ));
    } else {
      child = Padding(
        padding: EdgeInsetsDirectional.only(
            start: 10.w, end: 24.w, top: 10.h, bottom: 10.h),
        child: DefaultText(
          text: "${widget.message}",
          fontColor: whiteColor,
          fontSize: 13.sp,
        ),
      );
    }
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) { },
      builder: (context, state) {
        ChatCubit chatCubit = ChatCubit.get(context);
        return GestureDetector(
          onTap: (){
            launchUrl(Uri.parse('tel:+01093203745'));
          },
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
}
