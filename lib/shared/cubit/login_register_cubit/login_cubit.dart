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

  createUser(
      {email,
      firstName,
      lastName,
      password,
      ensurePassword,
      date,
      context,
      urlImage}) async {
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
      userCredentialRegister?.user?.updateDisplayName('$firstName$lastName');
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
      await auth.signOut();
      emit(LogoutSuccess());
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
      if (userListSearch != null) {
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

  // Search method for group screen
  searchGroupName({text, doc}) async {
    FirebaseFirestore data = FirebaseFirestore.instance;
    emit(SearchGroupNameLoading());
    await data
        .collection('users')
        .doc(doc)
        .collection('groups')
        .where(
          "name",
          isEqualTo: text,
        )
        .get()
        .then((value) {
      if (groupSearchList != []) {
        groupSearchList = [];
        groupSearchList = value.docs;
      } else {
        groupSearchList = value.docs;
      }
      emit(SearchGroupNameSuccess());
      if (kDebugMode) {
        print('user list = $groupSearchList');
      }
    }).catchError((error) {
      emit(SearchGroupNameError());
    });
    return groupSearchList;
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


}

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
