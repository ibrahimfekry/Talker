import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talki/layout/home_layout_screen.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
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

  @override
  void initState() {
    super.initState();
    LoginCubit.get(context).getGroupMembers(groupId: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    LoginCubit loginCubit = LoginCubit.get(context);
    return SafeArea(
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is LeaveGroupSuccess){
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context)=> HomeLayoutScreen()), (route) => false,);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: Icon(
                Icons.group,
                size: size.width / 14,
              ),
              title: Text(
                widget.groupName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: state is GetGroupMemberLoading
                ? const Center(child: CircularProgressIndicator(),)
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(
                        //   height: size.height / 8,
                        //   width: size.width / 1.15,
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //           height: size.height / 12,
                        //           child: Icon(
                        //             Icons.group,
                        //             size: size.width / 14,
                        //           )),
                        //       SizedBox(
                        //         width: size.width / 20,
                        //       ),
                        //       Text(widget.groupName, style: const TextStyle(color: Colors.white),),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height / 20,
                        ),
                        Text('${loginCubit.infoMembersList.length} members', style: const TextStyle(color: Colors.white),),
                        //Members Names
                        Flexible(
                          child: ListView.builder(
                            itemCount: loginCubit.infoMembersList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () => loginCubit.showRemoveDialog(
                                  index: index,
                                  groupId: widget.groupId,
                                  context: context
                                ),
                                leading: const Icon(Icons.account_circle),
                                title: Text(loginCubit.infoMembersList[index]['firstName'], style: const TextStyle(color: Colors.white),),
                                subtitle:
                                    Text(loginCubit.infoMembersList[index]['emailAddress'], style: const TextStyle(color: Colors.white),),
                                trailing: Text(loginCubit.infoMembersList[index]['isAdmin']
                                    ? 'Admin'
                                    : '', style: const TextStyle(color: Colors.white),),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddMembersInGroupInfo(
                                        groupId: widget.groupId,
                                        groupName: widget.groupName,
                                        membersList: loginCubit.infoMembersList,
                                      ))),
                          leading: const Icon(Icons.add_circle),
                          title: const Text('Add members', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        ListTile(
                          onTap: (){
                            loginCubit.onLeaveGroup(groupId: widget.groupId);
                          },
                          leading: const Icon(Icons.logout),
                          title: const Text('Leave Group', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
