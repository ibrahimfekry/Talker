import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget{
  static String id = 'AddScreen';
  const AddScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text('Add', style: TextStyle(color: Colors.white),),));
  }
}