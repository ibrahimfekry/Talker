import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talki/layout/home_layout_screen.dart';
import 'package:talki/shared/cubit/group_cubit/group_cubit.dart';
import 'package:talki/shared/cubit/group_cubit/group_state.dart';
import 'package:uuid/uuid.dart';

import '../GroupChatRoom.dart';

class CreateGroup extends StatefulWidget {
  List<Map<String, dynamic>>? membersList;

  CreateGroup({this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    GroupCubit groupCubit = GroupCubit.get(context);
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if(state is CreateGroupSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatRoom(
            groupName: _groupName.text,
            groupChatId: groupCubit.groupId ,)));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Group Name"),
            ),
            body: state is! CreateGroupLoading
                ? Column(
                    children: [
                      SizedBox(
                        height: size.height / 10,
                      ),
                      Container(
                        height: size.height / 14,
                        width: size.width,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: size.height / 14,
                          width: size.width / 1.15,
                          child: TextField(
                            controller: _groupName,
                            decoration: InputDecoration(
                              hintText: "Enter Group Name",
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
                      ElevatedButton(
                        onPressed: (){
                          groupCubit.createGroup();
                        },
                        child: const Text("Create Group"),
                      ),
                    ],
                  )
                : Container(
                    height: size.height,
                    width: size.width,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ));
      },
    );
  }
}
