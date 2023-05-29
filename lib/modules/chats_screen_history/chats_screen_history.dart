import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_cubit.dart';
import 'package:talki/shared/cubit/login_register_cubit/login_states.dart';
import '../../models/users_model.dart';
import '../../shared/components/widgets/chat_item_active.dart';
import '../../shared/components/widgets/child_chat_history.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';

class ChatsScreenHistory extends StatefulWidget {

  ChatsScreenHistory( {Key? key, this.googleId, this.emailId, this.destinationId,}) : super(key: key);

  ///////////////////////// variables
  static String id = 'ChatScreenHistory';
  String? emailId;
  dynamic googleId;
  dynamic destinationId;

  @override
  State<ChatsScreenHistory> createState() => _ChatsScreenHistoryState();
}

class _ChatsScreenHistoryState extends State<ChatsScreenHistory> with WidgetsBindingObserver{

  //////////////////////////// variables
  TextEditingController searchController = TextEditingController();
  FirebaseAuth authStates = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await firebaseFirestore.collection('users').doc(authStates.currentUser?.uid).update({
      "status" : status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      setStatus("Online");
    }else{
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    LoginCubit loginCubit = LoginCubit.get(context);
    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          List<UserModelRegister> userList = [];
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              userList.add(UserModelRegister.fromJson(snapshot.data?.docs[i]));
            }
            return BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => ChatActiveItem(
                                name: '${userList[index].firstName} ${userList[index].lastName}',
                                status: userList[index].status,
                                url: userList[index].url,
                              ),
                              separatorBuilder: (context, index) => SizedBox(width: 11.w,),
                              itemCount: userList.length),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        DefaultTextField(
                          color: whiteColor,
                          suffix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  loginCubit.searchUser(text: searchController.text,);
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: orangeColor,
                              )),
                          contentVertical: 11.h,
                          contentHorizontal: 12.w,
                          hintText: 'Search for contents',
                          controller: searchController,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        DefaultText(
                            text: 'Your Messages',
                            fontColor: whiteColor,
                            fontWeight: FontWeight.w800),
                        SizedBox(
                          height: 28.h,
                        ),
                        ConditionalBuilder(
                          condition: state is !SearchLoading || userList.isNotEmpty,
                          builder: (context) =>  Expanded(
                            child: loginCubit.userListSearch.isNotEmpty
                                ? ListView.separated(
                                    itemCount: loginCubit.userListSearch.length,
                                    itemBuilder: (context, index) => ItemChatHistory(
                                      firstName: loginCubit.userListSearch[index].firstName,
                                      lastName: loginCubit.userListSearch[index].lastName,
                                      emailId: widget.emailId,
                                      destinationId: loginCubit.userListSearch[index].emailAddress,
                                      googleId: widget.googleId,
                                      user1: loginCubit.registerAuth.currentUser?.uid,
                                      user2: loginCubit.userListSearch[index].uid,
                                      status: loginCubit.userListSearch[index].status,
                                      url: loginCubit.userListSearch[index].url,
                                    ),
                                    separatorBuilder: (context, index) => SizedBox(height: 13.h,),
                                  )
                                : ListView.separated(
                                    itemCount: userList.length,
                                    itemBuilder: (context, index) => ItemChatHistory(
                                      firstName: userList[index].firstName,
                                      lastName: userList[index].lastName,
                                      emailId: widget.emailId,
                                      destinationId:userList[index].emailAddress,
                                      googleId: widget.googleId,
                                      user1: loginCubit.registerAuth.currentUser?.uid,
                                      user2: userList[index].uid,
                                      status: userList[index].status,
                                      url: userList[index].url,
                                    ),
                                    separatorBuilder: (context, index) => SizedBox(height: 13.h,),
                                  ),
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator(),),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
