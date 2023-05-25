import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/constants/colors.dart';
import '../chat_screen/chat_cubit.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/chat_states.dart';

class ContactScreen extends StatefulWidget {
  static String id = 'ContactScreen';
  String? emailId;
  dynamic googleId;
  dynamic destinationId;
  ContactScreen({super.key, this.emailId, this.googleId, this.destinationId});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatCubit chatCubit = ChatCubit.get(context);
    return BlocConsumer < ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: state is PermissionLoading
              ? const Center(child: CircularProgressIndicator(),)
              : Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 15.h),
                child: ListView.separated(
                  itemCount: chatCubit.contacts.length,
                  itemBuilder: (context, index) {
                    if(chatCubit.contacts[index].displayName == null) {
                      return Container();
                    } else {
                      return GestureDetector(
                        onTap: (){
                          chatCubit.phoneNumber = "${chatCubit.contacts[index].displayName}\n + ${chatCubit.contacts[index].phones?[0].value}" ;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(emailId: widget.emailId, googleId: widget.googleId,destinationId: widget.destinationId,)),);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: silverColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: orangeColor,
                                  child: Text('${(chatCubit.contacts[index].displayName)?.substring(0,1).trim()}'),
                                ),
                                SizedBox(width: 10.w,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${chatCubit.contacts[index].displayName}'),
                                    // SizedBox(height: 3.h,),
                                    // Text('${chatCubit.contacts[index].phones?[0].value}'),
                                    //Text('mohamed'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context,index)=> SizedBox(height: 10.h,),),
              ),
        );
      },
    );
  }
}