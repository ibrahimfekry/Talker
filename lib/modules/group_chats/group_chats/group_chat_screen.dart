import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'create_group/add_members.dart';
import 'group_chat_room.dart';

  class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);
  static String id = "GroupScreen";

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  List groupList = [];
  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container(
          height: 200.h,
              child: ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => GroupChatRoom(
                            groupChatId: groupList[index]['id'],
                            groupName: groupList[index]['firstName'],
                          ))),
                  leading: Icon(Icons.group, color: Colors.white,),
                  title: Text(groupList[index]['name'], style: TextStyle(color: Colors.white),),
                );
              }),
            ),
        FloatingActionButton(
          child: const Icon(Icons.create),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddMembersInGroup())),
          tooltip: 'Create Group',
        ),
      ],
    );
  }
}
