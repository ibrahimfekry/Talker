import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/layout/home_layout_screen.dart';
import 'package:talki/modules/group_chats/group_chat_room.dart';
import 'package:talki/modules/group_chats/group_info.dart';
import 'package:talki/shared/components/component/components.dart';
import 'package:talki/shared/constants/colors.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../shared/components/widgets/add_member_Item.dart';
import '../../shared/components/widgets/text_form_field.dart';

class AddMembersInGroupInfo extends StatefulWidget {
  const AddMembersInGroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.membersList})
      : super(key: key);
  final String groupName, groupId;
  final List membersList;

  @override
  State<AddMembersInGroupInfo> createState() => _AddMembersInGroupInfoState();
}

class _AddMembersInGroupInfoState extends State<AddMembersInGroupInfo> {
  final TextEditingController searchController = TextEditingController();
  bool isExist = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if(state is AddMemberGroupInfoSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> GroupChatRoom(
              groupName: widget.groupName,
              groupChatId: widget.groupId,
              idAddMemberFromGroup: true,)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AddMemberGroupInfoLoading,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Add Members"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextField(
                      color: whiteColor,
                      suffix: ConditionalBuilder(
                        condition: state is! OnSearchGroupInfoLoading,
                        builder: (context) => GestureDetector(
                            onTap: () {
                              loginCubit.onSearchGroupInfo(
                                text: searchController.text,
                              );
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
                    SizedBox(height: 20.h,),
                    loginCubit.userMapGroupInfo != null
                        ? AddMemberItem (
                      iconColor: whiteColor,
                      firstName: loginCubit.userMapGroupInfo!['firstName'],
                      emailAddress: loginCubit.userMapGroupInfo!['emailAddress'],
                      icon: Icons.add,
                      onPress: (){
                        isExisted(loginCubit);
                        if(isExist){
                          defaultSnackBar(
                              context: context,
                              text: 'The user already exists',
                              color: Colors.blue
                          );
                        }else{
                          loginCubit.onAddMembersGroupInfo(
                              groupId: widget.groupId,
                              groupName: widget.groupName
                          );
                        }
                      },
                      url:loginCubit.userMapGroupInfo!['urlImage'],
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void isExisted(LoginCubit loginCubit) {
     for(int i = 0 ; i< loginCubit.infoMembersList.length ; i++){
      if(loginCubit.infoMembersList[i]['firstName'] == loginCubit.userMapGroupInfo!['firstName']){
        isExist = true ;
        break;
      }else{
        isExist = false ;
      }
    }
  }

}
