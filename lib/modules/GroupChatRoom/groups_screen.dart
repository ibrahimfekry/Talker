import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talki/shared/constants/colors.dart';
import 'GroupChatRoom.dart';
import 'create_group/add_members.dart';

class GroupsScreen extends StatefulWidget {
  static String id = 'GroupsScreen';
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
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
    await fireStore
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
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        isLoading
            ? Container(
                height: size.height/2,
                width: size.width/2,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SizedBox(
              width: size.width/2,
              height: size.height/2,
              child: ListView.builder(
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GroupChatRoom(
                            groupName: groupList[index]['name'],
                            groupChatId: groupList[index]['id'],
                          ),
                        ),
                      ),
                      leading: const Icon(Icons.group),
                      title: Text(groupList[index]['name'],
                        style: TextStyle(color: whiteColor),),
                    );
                  },
                ),
            ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddMembersInGroup(),
            ),
          ),
          child: const Icon(Icons.create, color: Colors.white,),
        ),
      ],
    );
  }
}
