// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
// import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../chat_screen/record_message/sound_player.dart';
// import '../chat_screen/record_message/sound_recorder.dart';
//
// class PlaySound extends StatefulWidget {
//   const PlaySound({Key? key}) : super(key: key);
//   static String id = 'play';
//   @override
//   State<PlaySound> createState() => _PlaySoundState();
// }
//
// class _PlaySoundState extends State<PlaySound> {
//   final recorder = SoundRecorder();
//   final player = SoundPlayer();
//   @override
//   void initState() {
//     super.initState();
//     recorder.init();
//     player.init();
//   }
//   @override
//   void dispose() {
//     player.dispose();
//     recorder.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:[
//             buildStart(),
//             buildSound( ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget buildStart(){
//     final isRecording = recorder.isRecording;
//     final icon = isRecording ?Icons.stop :Icons.mic;
//     final text = isRecording ?'Stop' : 'Start';
//     final backgroundColor = isRecording ? Colors.red : Colors.white;
//     final foregroundColor = isRecording ? Colors.white : Colors.black;
//
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: foregroundColor,
//         backgroundColor: backgroundColor,
//         maximumSize: Size(175.w, 50.h),
//       ),
//       icon: Icon(Icons.mic) ,
//       label:Text(text) ,
//       onPressed: ()async{
//         final isRecording = await recorder.toogleRecording();
//
//         setState(() {
//
//         });
//       },
//     );
//   }
//   Widget buildSound(){
//     final isRecording = player.isPlaying;
//     final icon = isRecording ?Icons.stop :Icons.mic;
//     final text = isRecording ?'Stop Recording' : 'Play Recording';
//     final backgroundColor = isRecording ? Colors.red : Colors.white;
//     final foregroundColor = isRecording ? Colors.white : Colors.black;
//
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: foregroundColor,
//         backgroundColor: backgroundColor,
//         maximumSize: Size(175.w, 50.h),
//       ),
//       icon: Icon(Icons.arrow_right) ,
//       label:Text(text) ,
//       onPressed: ()async{
//         await player.tooglePlaying(whenFinished: ()=> setState(() {
//
//         })
//         );
//         setState(() {
//
//         });
//       },
//     );
//   }
// }
//
//
//
// // ممكن نخلى الملف دا يبقى الstorage بتاعت firebase
// //ملف تخزين الاصوات
