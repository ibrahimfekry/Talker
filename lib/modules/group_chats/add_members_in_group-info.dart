import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talki/layout/home_layout_screen.dart';

import 'group_chat_screen.dart';

class AddMembersInGroupInfo extends StatefulWidget {
  AddMembersInGroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.membersList})
      : super(key: key);
  final String groupName, groupId;
  final List membersList;

  @override
  State<AddMembersInGroupInfo> createState() => _AddMembersInGroupInfoState();
}

class _AddMembersInGroupInfoState extends State<AddMembersInGroupInfo> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List membersList = [];

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('users')
        .where("firstName", isEqualTo: searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onAddMembers() async {
    membersList.add({
      'firstName': userMap!['firstName'],
      'emailAddress': userMap!['emailAddress'],
      'uid': userMap!['uid'],
      'isAdmin': false,
    });
    await firestore.collection('groups').doc(widget.groupId).update({
      'members': membersList,
    });
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('groups')
        .doc(widget.groupId)
        .set({
      'name': widget.groupName,
      'id': widget.groupId,
    });
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomeLayoutScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['firstName']),
                    subtitle: Text(userMap!['emailAddress']),
                    trailing: IconButton(
                      onPressed: onAddMembers,
                      icon: Icon(Icons.add),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
