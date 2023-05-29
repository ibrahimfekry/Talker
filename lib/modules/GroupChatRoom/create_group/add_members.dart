import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talki/shared/cubit/group_cubit/group_cubit.dart';
import 'package:talki/shared/cubit/group_cubit/group_state.dart';
import 'create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  //////////////////////// variables
  final TextEditingController searchController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  //////////////////////// init state
  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  ////////////////////////
  void getCurrentUserDetails() async {
    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await fireStore
        .collection('users')
        .where("email", isEqualTo: searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    GroupCubit groupCubit = GroupCubit.get(context);
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text("Add Members"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onRemoveMembers(index),
                      leading: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      //title: const Text(""),
                      title: Text(membersList[index]['name']),
                      subtitle: Text(membersList[index]['email']),
                      trailing: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
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
                      onPressed: () {
                        onSearch();
                      },
                      child: Text("Search"),
                    ),
              userMap != null
                  ? ListTile(
                      onTap: onResultTap,
                      leading: Icon(Icons.account_box),
                      title: Text(userMap!['name']),
                      subtitle: Text(userMap!['email']),
                      trailing: Icon(Icons.add),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        floatingActionButton: membersList.length >= 2
            ? FloatingActionButton(
                child: Icon(Icons.forward),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateGroup(
                      membersList: membersList,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
