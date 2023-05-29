import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../layout/home_layout_screen.dart';
import '../group_chat_room.dart';
import '../group_chat_screen.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key, required this.membersList}) : super(key: key);
  final List<Map<String, dynamic>> membersList;


  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  final FirebaseAuth auth =FirebaseAuth.instance;

  String? groupId;
  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    groupId = Uuid().v1();
    await firestore.collection('groups').doc(groupId).set({
      'group name':groupNameController.text,
      'members': widget.membersList,
      'id': groupId,
    });
    
    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];
      await firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        'name': groupNameController.text,
        'id': groupId,
      });
    }
    //add messages in group chat
    await firestore.collection('groups').doc(groupId).collection('chats').add({
      'message':'${auth.currentUser!.displayName} created this group',
      'type':'notify',
        });
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => HomeLayoutScreen()), (route) => false);
  }

  void deleteGroup()async{
    await firestore.collection('groups').doc(groupId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Name'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 18,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width / 1,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.12,
                    child: TextField(
                      controller: groupNameController,
                      decoration: InputDecoration(
                          hintText: 'Enter Group Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onLongPress: deleteGroup,
                  onPressed: createGroup,
                  child: const Text('Create Group'),
                ),
              ],
            ),
    );
  }
}
