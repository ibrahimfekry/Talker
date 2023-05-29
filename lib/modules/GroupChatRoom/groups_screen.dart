import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/group_cubit/group_cubit.dart';
import 'package:talki/shared/cubit/group_cubit/group_state.dart';
import 'GroupChatRoom.dart';
import 'add_members.dart';
import 'create_group/add_members.dart';
import 'create_group/create_group.dart';

class GroupsScreen extends StatefulWidget {
  static String id = 'GroupsScreen';
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  //final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //final FirebaseAuth auth = FirebaseAuth.instance;
  // @override
  // void initState() {
  //   super.initState();
  //   getAvailableGroups();
  // }

  // void getAvailableGroups() async {
  //   String uid = auth.currentUser!.uid;
  //   await fireStore
  //       .collection('users')
  //       .doc(uid)
  //       .collection('groups')
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       groupList = value.docs;
  //       isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    GroupCubit groupCubit = GroupCubit.get(context);
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            ConditionalBuilder(
                condition: state is !GetAvailableGroupLoading ,
                builder: (context) {
                  return SizedBox(
                    width: size.width / 2,
                    height: size.height / 2,
                    child: ListView.builder(
                      itemCount: groupCubit.groupList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GroupChatRoom(
                                groupName: groupCubit.groupList![index]['name'],
                                groupChatId: groupCubit.groupList![index]['id'],
                              ),
                            ),
                          ),
                          leading: const Icon(Icons.group),
                          title: Text(
                            groupCubit.groupList![index]['name'],
                            style: TextStyle(color: whiteColor),
                          ),
                        );
                      },
                    ),
                  );
                },
                fallback: (context) => Center(child: DefaultText(
                  text: 'There is no group',
                  fontSize: 18.sp,
                  fontColor: whiteColor
                ),)
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>  CreateGroup(),
                  ),
                ),
                child: const Icon(
                  Icons.create,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
