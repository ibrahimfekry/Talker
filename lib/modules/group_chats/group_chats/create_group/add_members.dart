import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../../../shared/components/widgets/add_member_Item.dart';
import '../../../../shared/components/widgets/text_form_field.dart';
import 'create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: DefaultText(
              text: "Add Members",
              fontSize: 20.sp,
            ),
            actions: [
              loginCubit.membersList.length >= 2 ? IconButton( onPressed: () {
                Navigator.of(context).push( MaterialPageRoute(
                  builder: (_) => CreateGroup( membersList: loginCubit.membersList,),),);
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
                            loginCubit.searchAddMember(
                                text: searchController.text);
                          },
                          child: Icon(Icons.search, color: orangeColor,)
                      ),
                      fallback: (context) => const Center(child: CircularProgressIndicator(),),
                    ),
                    contentVertical: 11.h,
                    contentHorizontal: 12.w,
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
        );
      },
    );
  }
}
