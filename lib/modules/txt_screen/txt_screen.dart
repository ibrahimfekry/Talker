import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_text_viewer/model/text_viewer.dart';
import 'package:flutter_text_viewer/screen/text_viewer_page.dart';
class TxtScreen extends StatelessWidget{
  String? message;
  static String id = 'PdfScreen';

  TxtScreen({super.key, this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TextViewerPage(
        textViewer: TextViewer.asset(
          '$message',
          highLightColor: Colors.yellow,
          focusColor: Colors.orange,
          ignoreCase: true,
        ),
        showSearchAppBar: true,
      )
    );
  }
}