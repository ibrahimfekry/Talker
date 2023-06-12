import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/components/component/components.dart';

class EmojiScreen extends StatefulWidget{
  TextEditingController? sendController = TextEditingController();
  EmojiScreen({super.key, this.sendController});
  @override
  State<EmojiScreen> createState() => _EmojiScreenState();
}

class _EmojiScreenState extends State<EmojiScreen> {
  bool emojiShowing = false;

  @override
  void dispose() {
    widget.sendController?.dispose();
    super.dispose();
  }

  // _onBackspacePressed() {
  //   widget.sendController!.text = widget.sendController!.text.characters.toString()
  //     .selection = TextSelection.fromPosition(
  //         TextPosition(offset: _controller.text.length));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Emoji Picker Example App'),
        ),
        body: Column(
          children: [
            Container(height: 400.h, child: showEmojiPicker())
          ],
        ),
      ),
    );
  }
}

