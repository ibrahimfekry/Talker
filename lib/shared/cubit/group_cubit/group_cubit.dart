import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/users_model.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());
  static GroupCubit get (context) => BlocProvider.of(context);

  // List<UserModelRegister> memberList = [];
  // searchUser({textSearch}) async {
  //   FirebaseFirestore data = FirebaseFirestore.instance;
  //   emit(SearchGroupLoading());
  //   await data.collection('users').where("firstName", isEqualTo: textSearch.text).get()
  //       .then((value) {
  //         memberList.add(UserModelRegister.fromJson(value.docs[0].data()));
  //         emit(SearchGroupSuccess());
  //         print(memberList);
  //   }).catchError((error){
  //     print('Search Error is $error');
  //     emit(SearchGroupError());
  //   });
  //   return memberList;
  // }

  // void getCurrentUserDetails() async {
  //   FirebaseFirestore data = FirebaseFirestore.instance;
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   await data.collection('users').doc(auth.currentUser!.uid).get().then((map) {
  //       memberList.add({
  //         "name": map['name'],
  //         "email": map['email'],
  //         "uid": map['uid'],
  //         "isAdmin": true,
  //       });
  //   });
  // }


}
