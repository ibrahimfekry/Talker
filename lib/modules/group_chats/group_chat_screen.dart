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
    CollectionReference groups = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid).collection('groups');
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
                              color: blueColor.withOpacity(0.7),
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
                                        firstName: '${snapshot.data?.docs[index]['firstName']}',
                                        lastName: '${snapshot.data?.docs[index]['lastName']}',
                                        status: snapshot.data?.docs[index]['status'],
                                        url: snapshot.data?.docs[index]['urlImage'],
                                        isGroup: true,
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
                            loginCubit.searchGroup(
                                text: searchController.text,
                            );
                          },
                          child: Icon(
                            Icons.search,
                            color: scaffoldColorDark,
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : state is SearchGroupSuccess
                            ? Expanded(
                                child: SizedBox(
                                  height: 200.h,
                                  child: ListView.builder(
                                      itemCount: loginCubit.groupSearch.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => GroupChatRoom(
                                                        groupChatId: '${loginCubit.groupSearch[index].id}',
                                                        groupName: '${loginCubit.groupSearch[index].groupName}',
                                                      ))),
                                          leading: Icon(
                                            Icons.group,
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          title: Text(
                                            '${loginCubit.groupSearch[index].groupName}',
                                            style: Theme.of(context).textTheme.bodyMedium,
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
                                          leading: Icon(
                                            Icons.group,
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          title: Text(
                                            snapshot.data?.docs[index]['name'],
                                            style: Theme.of(context).textTheme.bodyMedium,
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
