import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../../../layout/home_layout_screen.dart';
import '../../../../shared/components/widgets/add_member_Item.dart';
import '../../../../shared/components/widgets/default_button_create_group.dart';
import '../../../../shared/components/widgets/text_form_field.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  TextEditingController searchController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey <ScaffoldState> ();
  bool isBottomSheet = true;

  @override
  void initState() {
    super.initState();
    LoginCubit.get(context).getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is AddMemberSearchSuccess) {
          searchController.clear();
        }
        if (state is CreateGroupSuccess) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeLayoutScreen()),
                  (route) => false);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is CreateGroupLoading,
          child: Scaffold(
            key:scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: DefaultText(
                text: "Add Members",
                fontSize: 20.sp,
              ),
              actions: [
                loginCubit.membersList.length >= 2 ? IconButton( onPressed: () {
                  if(isBottomSheet){
                    scaffoldKey.currentState?.showBottomSheet((context){
                      return BlocConsumer <LoginCubit, LoginStates> (
                          listener: (context, state){},
                          builder: (context, state) => Container(
                            decoration: BoxDecoration(
                              color: scaffoldColorDark,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultText(
                                    text: "Create Group Name",
                                    fontSize: 20.sp,
                                    fontColor: whiteColor,
                                  ),
                                  SizedBox(height: 20.h,),
                                  DefaultTextField(
                                    color: whiteColor,
                                    hintText: 'Enter Group Name',
                                    controller: groupNameController,
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ButtonCreateDeleteGroup(
                                          text: 'Create Group',
                                          fontColor: whiteColor,
                                          backgroundColor: orangeColor,
                                          onTap: (){
                                            loginCubit.createGroup(
                                                text: groupNameController.text,
                                                memberList: loginCubit.membersList);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15.w,),
                                      Expanded(
                                        child: ButtonCreateDeleteGroup(
                                          text: 'Delete Group',
                                          fontColor: whiteColor,
                                          backgroundColor: orangeColor,
                                          onTap: (){
                                            loginCubit.deleteGroup();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    }).closed.then((value){
                      isBottomSheet = true;
                    });
                    isBottomSheet = false;
                  }else{
                    Navigator.pop(context);
                    isBottomSheet = true;
                  }
                  // Navigator.of(context).push( MaterialPageRoute(
                  //   builder: (_) => CreateGroup( membersList: loginCubit.membersList,),),);
                  },
                    icon: Icon(Icons.forward, color: orangeColor, size: 30,),
                ) : const SizedBox(),
                SizedBox(width: 10.w,),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 10.h,),
                        itemCount: loginCubit.membersList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AddMemberItem (
                            iconColor: whiteColor,
                            firstName: loginCubit.membersList[index]['firstName'],
                            emailAddress: loginCubit.membersList[index]['emailAddress'],
                            icon: Icons.close,
                            onPress: (){
                              loginCubit.onRemoveMembers(index);
                            },
                            url: loginCubit.membersList[index]['urlImage'],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height / 20,),
                    DefaultTextField(
                      color: whiteColor,
                      suffix: ConditionalBuilder(
                        condition: state is! AddMemberSearchLoading,
                        builder: (context) => GestureDetector(
                            onTap: () {
                              loginCubit.searchAddMember(text: searchController.text);
                            },
                            child: Icon(Icons.search, color: orangeColor,)
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator(),),
                      ),
                      hintText: 'Search for contents',
                      controller: searchController,
                    ),
                    SizedBox(height: size.height / 50,),
                    loginCubit.userMap != null ? AddMemberItem (
                      iconColor: whiteColor,
                      firstName: "${loginCubit.userMap?['firstName']}",
                      emailAddress: "${loginCubit.userMap?['emailAddress']}",
                      icon: Icons.add,
                      onPress: (){
                        loginCubit.onResultTap();
                      },
                      url: "${loginCubit.userMap?['urlImage']}",
                    ) : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
