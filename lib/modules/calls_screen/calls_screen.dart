import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';

class CallsScreen extends StatefulWidget {
  static String id = 'CallsScreen';
  CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Calls', style: TextStyle(color: Colors.white),),
    );
  }
}
