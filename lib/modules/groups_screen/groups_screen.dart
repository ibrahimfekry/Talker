import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget{
  static String id = 'GroupsScreen';
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text('groups', style: TextStyle(color: Colors.white),),));
  }
}