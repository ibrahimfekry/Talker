import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../shared/components/component/components.dart';
import '../../shared/constants/colors.dart';
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

  // Firestore Variables
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Register Methods
  changePasswordVisibilityRegister(){
    isPasswordRegisterNormal = !isPasswordRegisterNormal;
    emit(ChangePasswordRegisterVisibility());
  }

  changeEnsurePasswordVisibilityRegister(){
    isEnsurePasswordRegister = !isEnsurePasswordRegister;
    emit(ChangeEnsurePasswordRegisterVisibility());
  }

  createUser(String email, password, BuildContext context) async {
    emit(RegisterLoadingState());
    userCredentialRegister = await registerAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      defaultSnackBar(
          context : context ,
          color: scaffoldColorDark,
          text: 'Your Email is Generated successfully'
      );
      emit(RegisterSuccessState());
    }).catchError((e) {
      defaultSnackBar(
          context : context ,
          color: Colors.red,
          text: 'There is an error'
      );
      emit(RegisterErrorState());
    });
  }


  // Login Methods
  changePasswordVisibilityLogin(){
    isPasswordLogin = !isPasswordLogin;
    emit(ChangePasswordVisibility());
  }

  loginUserEmailAndPassword(String email, String password, BuildContext context) async {
    emit(LoginLoadingState());
    userCredentialLogin = await loginAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      defaultSnackBar(
          context : context ,
          color: scaffoldColorDark,
          text: 'Login Successfully'
      );
      emit(LoginSuccessState());
    }).catchError((error) {
      defaultSnackBar(
        context : context ,
        color: Colors. red,
        text: 'There is an error'
      );
      emit(LoginErrorState());
    });
  }

  Future <UserCredential?> signInWithGoogle(context) async {
    emit(LoginWithGoogleLoading());
    try{
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;
      credentialGoogle = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      defaultSnackBar(
          context : context ,
          color: scaffoldColorDark,
          text: 'Login Successfully'
      );
      cred =  await authGoogle.signInWithCredential(credentialGoogle!);
      emit(LoginWithGoogleSuccess());
    } catch (e){
      defaultSnackBar(
          context : context ,
          color: scaffoldColorDark,
          text: 'Error is $e'
      );
      emit(LoginWithGoogleError());
    }
    return cred ;
  }

  Future <void> signOut () async {
    await googleSignIn.signOut();
  }


  // Reset password Methods
  Future sendCodeResetPassword({email, context}) async{
    emit(SendCodeLoading());
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(SendCodeSuccess());
    }on FirebaseAuthException catch (e){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
      emit(SendCodeError());
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
}


