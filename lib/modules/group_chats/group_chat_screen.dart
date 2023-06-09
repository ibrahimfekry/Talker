import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../shared/components/widgets/chat_item_active.dart';
import '../../shared/components/widgets/text_form_field.dart';
import 'create_group/add_members.dart';
import 'group_chat_room.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);
  static String id = "GroupScreen";

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    LoginCubit.get(context).getAvailableGroups();
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    CollectionReference groups = FirebaseFirestore.instance.collection('users').doc(loginCubit.uid).collection('groups');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
        stream: groups.snapshots(),
        builder: (context, snapshot) {
          return BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddMembersInGroup()
                                )
                            );
                          },
                          child: Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: silverColor,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Icon(Icons.add, color: whiteColor,),
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Expanded(
                          child: SizedBox(
                            height: 60.h,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: users.snapshots(),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) => ChatActiveItem(
                                        name: '${snapshot.data?.docs[index]['firstName']} ${snapshot.data?.docs[index]['lastName']}',
                                        status: snapshot.data?.docs[index]['status'],
                                        url: snapshot.data?.docs[index]['urlImage'],
                                      ),
                                      separatorBuilder: (context, index) => SizedBox(width: 5.h,),
                                      itemCount: snapshot.data!.docs.length);
                                }else{
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    DefaultTextField(
                      color: whiteColor,
                      suffix: GestureDetector(
                          onTap: () {
                            loginCubit.searchGroupName(
                                text: searchController.text,
                                doc: loginCubit.uid);
                          },
                          child: Icon(
                            Icons.search,
                            color: orangeColor,
                          )
                      ),
                      hintText: 'Search for groups',
                      controller: searchController,
                    ),
                    SizedBox(height: 10.h,),
                    snapshot.data == null
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'There is no groups',
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          )
                        : loginCubit.groupSearchList == []
                            ? Expanded(
                                child: SizedBox(
                                  height: 200.h,
                                  child: ListView.builder(
                                      itemCount:
                                          loginCubit.groupSearchList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => GroupChatRoom(
                                                        groupChatId: loginCubit.groupSearchList[index]['id'],
                                                        groupName: loginCubit.groupSearchList[index]['name'],
                                                      ))),
                                          leading: const Icon(
                                            Icons.group,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            loginCubit.groupSearchList[index]
                                                ['name'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Expanded(
                                child: SizedBox(
                                  height: 200.h,
                                  child: ListView.builder(
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => GroupChatRoom(
                                                        groupChatId: snapshot.data?.docs[index]['id'],
                                                        groupName: snapshot.data?.docs[index]['name'],
                                                      ))),
                                          leading: const Icon(
                                            Icons.group,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            snapshot.data?.docs[index]['name'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                    SizedBox(height: 15.h,),
                  ],
                ),
              );
            },
          );
        });
  }
}
