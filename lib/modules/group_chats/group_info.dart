import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/layout/home_layout_screen.dart';
import 'package:talki/shared/components/component/components.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../shared/components/widgets/add_member_Item.dart';
import '../../shared/components/widgets/default_button_create_group.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import 'add_members_in_group-info.dart';


class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key, required this.groupId, required this.groupName}): super(key: key);

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
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if(state is LeaveGroupSuccess){
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)=> HomeLayoutScreen()), (route) => false,);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RemoveUserGroupLoading,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: const Icon(
                Icons.group,
              ),
              title: DefaultText(
                text: "${widget.groupName}\t\t\t(${loginCubit.infoMembersList.length})",
                fontColor: whiteColor,
                fontSize: 20.sp,
              ),
            ),
            body: state is GetGroupMemberLoading
                ? const Center(child: CircularProgressIndicator(),)
                : Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h,),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: loginCubit.infoMembersList.length,
                          //shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AddMemberItem (
                              iconColor: loginCubit.infoMembersList[index]['isAdmin'] ? orangeColor : Theme.of(context).iconTheme.color,
                              firstName: '${loginCubit.infoMembersList[index]['firstName']}',
                              emailAddress: '${loginCubit.infoMembersList[index]['emailAddress']}',
                              icon: loginCubit.infoMembersList[index]['isAdmin']? Icons.person : Icons.close,
                              onPress: (){
                                loginCubit.removeUser(
                                    index: index,
                                    groupId: widget.groupId,
                                );
                              },
                              url: loginCubit.infoMembersList[index]['urlImage'],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      ButtonCreateDeleteGroup(
                        fontColor: whiteColor,
                        backgroundColor: orangeColor,
                        text: 'Add Members',
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => AddMembersInGroupInfo(
                                    groupId: widget.groupId,
                                    groupName: widget.groupName,
                                    membersList: loginCubit.infoMembersList,
                                  )));
                        },
                      ),
                      SizedBox(height: 20.h,),
                      ButtonCreateDeleteGroup(
                        fontColor: whiteColor,
                        backgroundColor: orangeColor,
                        text: 'Leave Group',
                        onTap: (){
                          loginCubit.onLeaveGroup(groupId: widget.groupId);
                        },
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}
