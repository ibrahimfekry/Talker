import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
class PdfScreen extends StatelessWidget{

  static String id = 'PdfScreen';
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: PDF().cachedFromUrl(message),
    );
  }
}