import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_members_in_group-info.dart';
import 'group_chat_screen.dart';

class GroupInfo extends StatefulWidget {
  GroupInfo({Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  final String groupName, groupId;
  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List membersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getGroupMembers();
  }

  //to check if the user is admin
  bool checkAdmin() {
    bool isAdmin = false;
    membersList.forEach((element) {
      if (element['uid'] == auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  void getGroupMembers() async {
    await firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((value) {
      setState(() {
        membersList = value['members'];
        isLoading = false;
      });
    });
  }

  void showRemoveDialog(int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: ListTile(
              onTap: () => removeUser(index),
              title: Text('Remove this member'),
            ),
          );
        });
  }

  void removeUser(int index) async {
    if (checkAdmin()) {
      if (auth.currentUser!.uid != membersList[index]['uid']) {
        String uid = membersList[index]['uid'];

        setState(() {
          isLoading = true;
          membersList.removeAt(index);
        });

        //update list members
        await firestore.collection('groups').doc(widget.groupId).update({
          'members': membersList,
        });

        await firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupId)
            .delete();
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('can' 't Remove ');
    }
  }

  void onLeaveGroup() async {
    //if the user is admin then he can't leave the group
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });
      String uid = auth.currentUser!.uid;
      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == uid) {
          membersList.removeAt(i);
        }
      }
      await firestore.collection('groups').doc(widget.groupId).update({
        'members': membersList,
      });
      await firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => GroupScreen()),
          (route) => false);
    } else {
      print('Can''tLeft group');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                    Container(
                      height: size.height / 8,
                      width: size.width / 1.15,
                      child: Row(
                        children: [
                          Container(
                              height: size.height / 12,
                              child: Icon(
                                Icons.group,
                                size: size.width / 14,
                              )),
                          SizedBox(
                            width: size.width / 20,
                          ),
                          Text(widget.groupName),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                      child: Text('${membersList.length} members'),
                    ),
                    //Members Names
                    Flexible(
                      child: ListView.builder(
                        itemCount: membersList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => showRemoveDialog(index),
                            leading: Icon(Icons.account_circle),
                            title: Text(membersList[index]['firstName']),
                            subtitle: Text(membersList[index]['emailAddress']),
                            trailing: Text(
                                membersList[index]['isAdmin'] ? 'Admin' : ''),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    ListTile(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> AddMembersInGroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        membersList: membersList,
                      ))),
                      leading: Icon(Icons.add_circle),
                      title: Text('Add members'),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    ListTile(
                      onTap: onLeaveGroup,
                      leading: Icon(Icons.logout),
                      title: Text('Leave Group'),
                    ),

                  ],
                ),
              ),
      ),
    );
  }
}
