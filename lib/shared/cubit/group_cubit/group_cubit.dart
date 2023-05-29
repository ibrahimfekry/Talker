import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/users_model.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());
  static GroupCubit get(context) => BlocProvider.of(context);

  List? groupList;
  void getAvailableGroups() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    String uid = auth.currentUser!.uid;
    emit(GetAvailableGroupLoading());
    await fireStore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      groupList = value.docs;
      emit(GetAvailableGroupSuccess());
    }).catchError((error){
      if (kDebugMode) {print("Error is $error");}
      emit(GetAvailableGroupError());
    });
  }

  String? groupId;
  void createGroup() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    groupId = const Uuid().v1();
    emit(CreateGroupLoading());
    try{
      await fireStore.collection('groups').doc(groupId).set({
        "admin": auth.currentUser?.uid,
        "id": groupId,
      });
      await fireStore.collection('groups').doc(groupId).collection('chats').add({
        "message": "${auth.currentUser!.displayName} Created This Group.",
        "type": "notify",
      });
      print('name = ${auth.currentUser?.displayName}');
      emit(CreateGroupSuccess());
    }catch (e) {
      if (kDebugMode) {print("Error is $e");}
      emit(CreateGroupError());
    }
    // for (int i = 0; i < widget.membersList!.length; i++) {
    //   String uid = widget.membersList![i]['uid'];
    //   await fireStore
    //       .collection('users')
    //       .doc(uid)
    //       .collection('groups')
    //       .doc(groupId)
    //       .set({
    //     "name": _groupName.text,
    //     "id": groupId,
    //   });
    // }
  }

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
