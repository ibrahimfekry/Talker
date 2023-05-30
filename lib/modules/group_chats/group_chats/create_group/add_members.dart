import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';

import 'create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController searchController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    LoginCubit.get(context).getCurrentUserDetails();
  }

  void onResultTap() {
    bool isAlreadyExist = false;
    for (int i = 0; i < LoginCubit.get(context).membersList.length; i++) {
      if (LoginCubit.get(context).membersList[i]['uid'] == LoginCubit.get(context).userMap!['uid']) {
        isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      setState(() {
        LoginCubit.get(context).membersList.add({
          "firstName": LoginCubit.get(context).userMap!['firstName'],
          "emailAddress": LoginCubit.get(context).userMap!['emailAddress'],
          "uid": LoginCubit.get(context).userMap!['uid'],
          "isAdmin": false,
        });

        LoginCubit.get(context).userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (LoginCubit.get(context).membersList[index]['uid'] != auth.currentUser!.uid) {
      setState(() {
        LoginCubit.get(context).membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Members"),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: loginCubit.membersList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          color: whiteColor,
                        ),
                        title: Text(
                          loginCubit.membersList[index]['firstName'],
                          style: TextStyle(color: whiteColor),
                        ),
                        subtitle: Text(loginCubit.membersList[index]['emailAddress'],
                            style: TextStyle(color: whiteColor)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => onRemoveMembers(index),
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
                  child: SizedBox(
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
                SizedBox(height: size.height / 50,),
                state is AddMemberSearchLoading
                    ? Container(
                        height: size.height / 12,
                        width: size.height / 12,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: (){
                          loginCubit.searchAddMember(text: searchController.text);
                        },
                        child: Text("Search"),

                      ),
                loginCubit.userMap != null
                    ? ListTile(
                        leading: Icon(Icons.account_box, color: whiteColor,),
                        title: Text("${loginCubit.userMap?['firstName']}", style: TextStyle(color: whiteColor),),
                        subtitle: Text("${loginCubit.userMap?['emailAddress']}", style: TextStyle(color: whiteColor)),
                        trailing: IconButton(
                          onPressed: onResultTap,
                          icon: Icon(Icons.add, color: whiteColor,),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          floatingActionButton: loginCubit.membersList.length >= 2
              ? FloatingActionButton(
                  child: const Icon(Icons.forward),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateGroup(
                        membersList: loginCubit.membersList,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        );
      },
    );
  }
}
