import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talki/models/group_model.dart';
import 'package:uuid/uuid.dart';
import '../../../models/users_model.dart';
import '../../components/component/components.dart';
import '../../constants/colors.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginState());
  static LoginCubit get(context) => BlocProvider.of(context);

  // Register variables
  bool isPasswordRegisterNormal = true;
  bool isEnsurePasswordRegister = true;
  FirebaseAuth registerAuth = FirebaseAuth.instance;
  UserCredential? userCredentialRegister;

  // Login variables
  bool isPasswordLogin = true;
  FirebaseAuth loginAuth = FirebaseAuth.instance;
  UserCredential? userCredentialLogin;
  FirebaseAuth authGoogle = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  AuthCredential? credentialGoogle;
  UserCredential? userGoogleCredential;
  dynamic googleId;
  dynamic cred;

  // reset password
  bool isResetPassword = true;
  bool isResetConfirmPassword = true;

  resetPasswordVisibility() {
    isResetPassword = !isResetPassword;
    emit(ChangeResetPassword());
  }

  resetConfirmPasswordVisibility() {
    isResetConfirmPassword = !isResetConfirmPassword;
    emit(ChangeConfirmResetPassword());
  }

  // FireStore Variables
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // variables for available group
  final FirebaseFirestore fireStoreGroup = FirebaseFirestore.instance;
  final FirebaseAuth authGroup = FirebaseAuth.instance;
  List groupList = [];
  List groupSearchList = [];

  // Register Methods
  changePasswordVisibilityRegister() {
    isPasswordRegisterNormal = !isPasswordRegisterNormal;
    emit(ChangePasswordRegisterVisibility());
  }

  changeEnsurePasswordVisibilityRegister() {
    isEnsurePasswordRegister = !isEnsurePasswordRegister;
    emit(ChangeEnsurePasswordRegisterVisibility());
  }

  createUser({email, firstName, lastName, password, ensurePassword, date, context, urlImage}) async {
    emit(RegisterLoadingState());
    userCredentialRegister = await registerAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      defaultSnackBar(
          context: context,
          color: scaffoldColorDark,
          text: 'Your Email is Generated successfully');
      users.doc(FirebaseAuth.instance.currentUser?.uid).set({
        'urlImage': urlImage,
        'emailAddress': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'ensurePassword': ensurePassword,
        'date': date,
        'status': 'Offline',
        'uid': FirebaseAuth.instance.currentUser?.uid,
      });
      print('name is = ${userCredentialRegister?.user?.displayName}');
      emit(RegisterSuccessState());
    }).catchError((e) {
      defaultSnackBar(
          context: context, color: Colors.red, text: 'There is an error');
      emit(RegisterErrorState());
    });
  }

  File? file;
  var imagePicker = ImagePicker();
  String? url;
  uploadImage() async {
    emit(UploadImageRegisterLoading());
    try {
      XFile? imgPicked =
          await imagePicker.pickImage(source: ImageSource.gallery);
      var nameImage = basename(imgPicked!.path);
      if (imgPicked != null) {
        file = File(imgPicked.path);
        var random = Random().nextInt(10000);
        nameImage = '$random$nameImage';
        var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
        print(file);
        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();
        print('Url Image : $url');
      }
      emit(UploadImageRegisterSuccess());
    } catch (e) {
      if (kDebugMode) {
        print('error is $e');
      }
      emit(UploadImageRegisterError());
    }
  }

  // Login Methods
  changePasswordVisibilityLogin() {
    isPasswordLogin = !isPasswordLogin;
    emit(ChangePasswordVisibility());
  }

  loginUserEmailAndPassword({email, password, context}) async {
    emit(LoginLoadingState());
    userCredentialLogin = await loginAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      defaultSnackBar(
          context: context,
          color: scaffoldColorDark,
          text: 'Login Successfully');
      emit(LoginSuccessState());
    }).catchError((error) {
      defaultSnackBar(
          context: context, color: Colors.red, text: 'There is an error');
      emit(LoginErrorState());
    });
  }

  Future<UserCredential?> signInWithGoogle(context) async {
    emit(LoginWithGoogleLoading());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;
      credentialGoogle = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      defaultSnackBar(
          context: context,
          color: scaffoldColorDark,
          text: 'Login Successfully');
      cred = await authGoogle.signInWithCredential(credentialGoogle!);
      users.doc(FirebaseAuth.instance.currentUser?.uid).set({
        'urlImage': FirebaseAuth.instance.currentUser?.photoURL,
        'emailAddress': FirebaseAuth.instance.currentUser?.email,
        'firstName': FirebaseAuth.instance.currentUser?.displayName,
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'lastName': "",
        'password': "",
        'ensurePassword': "",
        'date': "",
        'status': 'Offline',
      });
      emit(LoginWithGoogleSuccess());
    } catch (e) {
      defaultSnackBar(
          context: context, color: scaffoldColorDark, text: 'Error is $e');
      emit(LoginWithGoogleError());
    }
    return cred;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }

  Future logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    emit(LogoutLoading());
    try {
      await auth.signOut().then((value){
        emit(LogoutSuccess());
      }).catchError((error){
        emit(LogoutError());
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(LogoutError());
    }
  }

  // Reset password Methods
  Future sendCodeResetPassword({email, context}) async {
    emit(SendCodeLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(SendCodeSuccess());
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
      emit(SendCodeError());
    }
  }

  // Search method for chat historyScreen
  List<UserModelRegister> userListSearch = [];
  searchUser({text}) async {
    FirebaseFirestore data = FirebaseFirestore.instance;
    emit(SearchLoading());
    await data
        .collection('users')
        .where(
          "firstName",
          isEqualTo: text,
        )
        .get()
        .then((value) {
      if (userListSearch != []) {
        userListSearch = [];
        userListSearch.add(UserModelRegister.fromJson(value.docs[0].data()));
      } else {
        userListSearch.add(UserModelRegister.fromJson(value.docs[0].data()));
      }
      emit(SearchSuccess());
      if (kDebugMode) {
        print('user list = $userListSearch');
      }
    }).catchError((error) {
      emit(SearchLoading());
    });
    return userListSearch;
  }

  // get Available groups
  String? uid;
  void getAvailableGroups() async {
    emit(GetAvailableGroupsLoading());
    uid = authGroup.currentUser!.uid;
    await fireStoreGroup
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      groupList = value.docs;
      emit(GetAvailableGroupsSuccess());
    }).catchError((error) {
      emit(GetAvailableGroupsError());
    });
  }
  
  // get Current user details
  List<Map<String, dynamic>> membersList = [];
  void getCurrentUserDetails() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    emit(GetCurrentUserDetailsLoading());
    if (membersList.isEmpty) {
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((map) {
        membersList.add({
          "firstName": map['firstName'],
          "emailAddress": map['emailAddress'],
          "uid": map['uid'],
          "urlImage" : map['urlImage'],
          "isAdmin": true,
        });
        emit(GetCurrentUserDetailsSuccess());
      }).catchError((error) {
        emit(GetCurrentUserDetailsError());
      });
    }
  }

  // search for add member to create group
  Map<String, dynamic>? userMap;
  searchAddMember({required String text}) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    emit(AddMemberSearchLoading());
    await fireStore.collection('users').where("firstName", isEqualTo: text).get().then((value) {
      if (userMap == {}) {
        userMap = value.docs[0].data();
      } else {
        userMap = {};
        userMap = value.docs[0].data();
      }
      if (kDebugMode) {print(userMap);}
      emit(AddMemberSearchSuccess());
    }).catchError((error) {
      if (kDebugMode) {print("error search = $error");}
      emit(AddMemberSearchError());
    });
    return userMap;
  }

  // on result add members
  onResultTap() {
    bool isAlreadyExist = false;
    emit(OnResultAddMembersLoading());
    try{
      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == userMap!['uid']) {
          isAlreadyExist = true;
        }
      }
      if (!isAlreadyExist) {
        membersList.add({
          "firstName": userMap!['firstName'],
          "emailAddress": userMap!['emailAddress'],
          "uid": userMap!['uid'],
          "urlImage" : userMap!['urlImage'],
          "isAdmin": false,
        });
        userMap = null;
      }
      emit(OnResultAddMembersSuccess());
    }catch(e){
      emit(OnResultAddMembersError());
    }
  }

  // remove member from add member
  void onRemoveMembers(int index) {
    FirebaseAuth auth = FirebaseAuth.instance;
    emit(RemoveMemberFromAddMemberLoading());
    if (membersList[index]['uid'] != auth.currentUser!.uid) {
        membersList.removeAt(index);
        emit(RemoveMemberFromAddMemberSuccess());
    }else{
      emit(RemoveMemberFromAddMemberError());
    }
  }

  // create group
  String? groupId;
  void createGroup({required String text, required List memberList}) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    emit(CreateGroupLoading());
    try{
      groupId = const Uuid().v1();
      await fireStore.collection('groups').doc(groupId).set({
        'groupName': text,
        'members': memberList,
        'id': groupId,
      });
      for (int i = 0; i < membersList.length; i++) {
        String uid = membersList[i]['uid'];
        await fireStore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .set({
          'name': text,
          'id': groupId,
        });
      }
      //add messages in group chat
      await fireStore.collection('groups').doc(groupId).collection('chats').add({
        'message':'${auth.currentUser!.displayName} created this group',
        'type':'notify',
      });
      emit(CreateGroupSuccess());
    }catch (e){
      if (kDebugMode) {print("create group error is $e");}
      emit(CreateGroupError());
    }
  }

  // delete group
  void deleteGroup()async{
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    emit(DeleteGroupLoading());
    try{
      await fireStore.collection('groups').doc(groupId).delete();
      emit(DeleteGroupSuccess());
    }catch (e){
      emit(DeleteGroupError());
    }
  }

  // check the admin
  final FirebaseFirestore infoFireStore = FirebaseFirestore.instance;
  final FirebaseAuth infoAuth = FirebaseAuth.instance;
  List infoMembersList = [];

  bool checkAdmin() {
    bool isAdmin = false;
    infoMembersList.forEach((element) {
      if (element['uid'] == infoAuth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  // get group members
  void getGroupMembers({required groupId}) async {
    emit(GetGroupMemberLoading());
    await infoFireStore
        .collection('groups')
        .doc(groupId)
        .get()
        .then((value) {
      infoMembersList = value['members'];
        emit(GetGroupMemberSuccess());
    }).catchError((error){
      emit(GetGroupMemberError());
    });
  }

  // remove user from group
  void removeUser({required int index, required groupId}) async {
    emit(RemoveUserGroupLoading());
    try{
      if (checkAdmin()) {
        if (infoAuth.currentUser!.uid != infoMembersList[index]['uid']) {
          String uid = infoMembersList[index]['uid'];
          infoMembersList.removeAt(index);
          //update list members
          await infoFireStore.collection('groups').doc(groupId).update({
            'members': infoMembersList,
          });
          await infoFireStore
              .collection('users')
              .doc(uid)
              .collection('groups')
              .doc(groupId)
              .delete();
        }
        emit(RemoveUserGroupSuccess());
      } else {
        print('cann\'t Remove ');
        emit(RemoveUserGroupError());
      }
    }catch (e){
      emit(RemoveUserGroupError());
    }
  }

  // On leave the group
  void onLeaveGroup({required groupId}) async {
    emit(LeaveGroupLoading());
    try{
      //if the user is admin then he can't leave the group
      if (!checkAdmin()) {
        String uid = infoAuth.currentUser!.uid;
        for (int i = 0; i < infoMembersList.length; i++) {
          if (infoMembersList[i]['uid'] == uid) {
            infoMembersList.removeAt(i);
          }
        }
        await infoFireStore.collection('groups').doc(groupId).update({
          'members': infoMembersList,
        });
        await infoFireStore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .delete();
        emit(LeaveGroupSuccess());
      } else {
        print('Can\'t Left group');
        emit(LeaveGroupError());
      }
    }catch (e){
      print("Error Leaving = $e");
      emit(LeaveGroupError());
    }
  }

  // on search add member group info
  FirebaseFirestore fireStoreGroupInfo = FirebaseFirestore.instance;
  Map<String, dynamic>? userMapGroupInfo;
  List membersListGroupInfo = [];
  FirebaseAuth authGroupInfo = FirebaseAuth.instance;
  void onSearchGroupInfo({text}) async {
    emit(OnSearchGroupInfoLoading());
    try{
      await fireStoreGroupInfo
          .collection('users')
          .where("firstName", isEqualTo: text)
          .get()
          .then((value) {
        userMapGroupInfo = value.docs[0].data();
        if (kDebugMode) {print(userMapGroupInfo);}
      });
      emit(OnSearchGroupInfoSuccess());
    }catch(e){
      emit(OnSearchGroupInfoError());
    }
  }

  // add member in group info
  void onAddMembersGroupInfo({groupId, groupName}) async {
    emit(AddMemberGroupInfoLoading());
    try{
      infoMembersList.add({
        'firstName': userMapGroupInfo!['firstName'],
        'emailAddress': userMapGroupInfo!['emailAddress'],
        'uid': userMapGroupInfo!['uid'],
        "urlImage" : userMapGroupInfo!['urlImage'],
        'isAdmin': false,
      });
      await fireStoreGroupInfo.collection('groups').doc(groupId).update({
        'members': infoMembersList,
      });
      await fireStoreGroupInfo
          .collection('users')
          .doc(authGroupInfo.currentUser!.uid)
          .collection('groups')
          .doc(groupId)
          .set({
        'name': groupName,
        'id': groupId,
      });
      emit(AddMemberGroupInfoSuccess());
    }catch(e){
      if (kDebugMode) {print('Error group Info = $e');}
      emit(AddMemberGroupInfoError());
    }
  }

  // get profile data
  Map<String, dynamic> profileData = {};
  getProfileData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    emit(GetProfileDataLoading());
    await fireStore.collection('users').where('emailAddress' , isEqualTo: FirebaseAuth.instance.currentUser?.email).get().then((value) {
      if (profileData == {}) {
        profileData = value.docs[0].data();
      } else {
        profileData = {};
        profileData = value.docs[0].data();
      }
      if (kDebugMode) {print(profileData);}
      emit(GetProfileDataSuccess());
    }).catchError((error) {
      if (kDebugMode) {print("error search = $error");}
      emit(GetProfileDataError());
    });
    return profileData;
  }

  // update profile
  CollectionReference usersProfile = FirebaseFirestore.instance.collection('users');
  updateProfile({required firstName, required lastName, date, urlImage, emailAddress}) async{
    emit(UpdateProfileLoading());
    try{
      await users.doc(FirebaseAuth.instance.currentUser?.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'date': date,
        'urlImage': urlImage,
        'emailAddress' : emailAddress
      }).then((value){
        emit(UpdateProfileSuccess());
      });
    }catch (e){
      emit(UpdateProfileError());
    }
  }

  File? fileUpdate;
  var imagePickerUpdate = ImagePicker();
  String? urlUpdate;
  updateImage() async {
    emit(UpdateImageLoading());
    try {
      XFile? imgPicked =
      await imagePickerUpdate.pickImage(source: ImageSource.gallery);
      var nameImage = basename(imgPicked!.path);
      if (imgPicked != null) {
        fileUpdate = File(imgPicked.path);
        var random = Random().nextInt(10000);
        nameImage = '$random$nameImage';
        var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
        print(fileUpdate);
        await refStorage.putFile(fileUpdate!);
        urlUpdate = await refStorage.getDownloadURL();
        print('Url update Image : $urlUpdate');
      }
      emit(UpdateImageSuccess());
    } catch (e) {
      if (kDebugMode) {
        print('error is $e');
      }
      emit(UpdateImageError());
    }
  }

  // update password
  updatePassword({password}) async{
    emit(UpdatePasswordLoading());
    try{
      await FirebaseAuth.instance.currentUser?.updatePassword(password).then((value){
        emit(UpdatePasswordSuccess());
      }).catchError((error){
        emit(UpdatePasswordError());
      });
    }catch(e){
      emit(UpdatePasswordError());
    }
  }

  //////////search for group
  List<GroupModel> groupSearch = [];
  searchGroup({text}) async {
    FirebaseFirestore data = FirebaseFirestore.instance;
    emit(SearchGroupLoading());
    await data.collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('groups')
        .where(
      "name",
      isEqualTo: text,)
        .get()
        .then((value) {
      if (groupSearch != []) {
        groupSearch = [];
        groupSearch.add(GroupModel.fromJson(value.docs[0].data()));
      } else {
        groupSearch.add(GroupModel.fromJson(value.docs[0].data()));
      }
      emit(SearchGroupSuccess());
      if (kDebugMode) {
        print('user list = $groupSearch');
      }
    }).catchError((error) {
      emit(SearchGroupError());
    });
    return groupSearch;
  }

}






















// // show remove dialog
// void showRemoveDialog({required int index, context, groupId}) {
//   showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           content: ListTile(
//             onTap: () => removeUser(index: index, groupId: groupId),
//             title: const Text('Remove this member'),
//           ),
//         );
//       });
// }



// facebook authentication
// FacebookLogin facebookLogin = FacebookLogin();
// FirebaseAuth authFacebook = FirebaseAuth.instance;

// void facebookSignInMethod () async {
//   FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);
//   final accessToken = facebookLoginResult.accessToken.token;
//   if(facebookLoginResult.status == FacebookLoginStatus.loggedIn){
//     final faceCredential = FacebookAuthProvider.credential(accessToken);
//     authFacebook.signInWithCredential(faceCredential);
//   }
// }

// Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult loginResult = await FacebookAuth.instance.login();
//
//   // Create a credential from the access token
//   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
//
//   // Once signed in, return the UserCredential
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }

//another method to create user
// Future <User?> createAnotherUser ({email, password}) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
//   User? user;
//   emit(RegisterLoadingState());
//   try{
//     user = (await auth.createUserWithEmailAndPassword(email: email, password: password)).user;
//     if(user != null){
//       if (kDebugMode) {print('Email created successfully');}
//       emit(RegisterSuccessState());
//     }else{
//       if (kDebugMode) {print("Account creation fail");}
//       emit(RegisterErrorState());
//     }
//   }catch(e){
//     if (kDebugMode) {print(e);}
//     emit(RegisterErrorState());
//   }
//   return user ;
// }

// another way to login
// Future <User?> loginWithEmailAndPassword ({email, password}) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   User? user;
//   emit(LoginLoadingState());
//   try{
//     user = (await auth.signInWithEmailAndPassword(email: email, password: password)).user;
//     if(user != null){
//       if (kDebugMode) {print('Login successfully');}
//       emit(LoginSuccessState());
//     }else{
//       if (kDebugMode) {print('Login error');}
//       emit(LoginErrorState());
//     }
//   }catch(e){
//     if (kDebugMode) {print(e);}
//     emit(LoginErrorState());
//   }
//   return user;
// }
