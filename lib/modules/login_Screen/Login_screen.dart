import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talki/shared/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../layout/home_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/constants.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../../shared/cubit/login_register_cubit/login_states.dart';
import '../forget_password_screen/forget_password_screen.dart';
import '../register_screen/register_screen.dart';


class LoginScreen extends StatelessWidget {

  ///////////////////////////// Variables
  LoginScreen({Key? key, this.emailId}) : super(key: key);
  static String id = 'LoginScreen';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserCredential? credential;
  String? emailId;
  GlobalKey <FormState> formKey = GlobalKey <FormState>();

  //////////////////////////// Method Build
  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer <LoginCubit, LoginStates> (
        listener: (context, state){
          if (state is LoginSuccessState ){
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) =>
                  HomeLayoutScreen(emailId: emailId,)), (route) => false,);
          }
          if (state is LoginWithGoogleSuccess){
            isGoogleEmail = true;
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) =>
                  HomeLayoutScreen(googleId: loginCubit.googleId,)), (route) => false,);
          }
          if(state is LoginSuccessState || state is LoginErrorState){
            emailController.clear();
            passwordController.clear();
          }
          if(state is SignWithFacebookSuccess){
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) =>
                  HomeLayoutScreen()), (route) => false,);
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 54.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/chat_logo.svg',width: 210,height: 150,),
                        ],
                      ),
                      SizedBox(height: 34.h,),
                      DefaultTextField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }
                          return null;
                        },
                        borderRadius: 10.r,
                        color:  Theme.of(context).focusColor,
                        controller: emailController,
                        hintText: 'Enter your email address',
                        prefix: Padding(
                          padding: EdgeInsetsDirectional.only(start: 15.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset('assets/images/email_icon.svg', width: 16.w, height: 16.h,),
                            ],
                          ),
                        ),
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 21.h,),
                      DefaultTextField(
                        borderRadius: 10.r,
                        color:  Theme.of(context).focusColor,
                        controller: passwordController,
                        obscureText: loginCubit.isPasswordLogin,
                        hintText: 'Password',
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: EdgeInsetsDirectional.only(start: 15.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset('assets/images/icon_lock.svg', width: 16.w, height: 21.h,),
                            ],
                          ),
                        ),
                        suffix: GestureDetector(
                          onTap: (){
                            loginCubit.changePasswordVisibilityLogin();
                          },
                          child: loginCubit.isPasswordLogin ? Icon(Icons.visibility_off, color: silverColor,) : Icon(Icons.visibility, color: silverColor,),
                        ),
                        textInputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 12.h,),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, RegisterScreen.id);
                                },
                                child: DefaultText(
                                    fontColor: blueColor,
                                    text: 'Create a new account'
                                ),
                              )),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, ForgetPasswordScreen.id);
                            },
                            child: DefaultText(
                                fontColor: blueColor,
                                text: 'Forget Password!'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 36.h,),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                child:DefaultText(
                                  text: 'Sign in ',
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )),
                          ConditionalBuilder(
                            condition: state is !LoginLoadingState,
                            builder: (context) => GestureDetector(
                              onTap: () async {
                                emailId = emailController.text;
                                if(formKey.currentState!.validate()){
                                  await loginCubit.loginUserEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context
                                  );
                                }
                              },
                              child: SvgPicture.asset('assets/images/icon_arrow_right.svg',),
                            ),
                            fallback: (context) => const Center (child: CircularProgressIndicator(),),
                          ),
                        ],
                      ),
                      SizedBox(height: 35.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultText(
                            text: 'Sign in with',
                            fontColor: silverColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConditionalBuilder(
                            condition: state is !LoginWithGoogleLoading,
                            builder: (context) => GestureDetector(
                                onTap: () async {
                                  credential = await loginCubit.signInWithGoogle(context);
                                  loginCubit.googleId = credential?.user?.email;
                                },
                                child: SvgPicture.asset('assets/images/icon_google.svg')
                            ),
                            fallback: (context) => const Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(width: 20.h,),
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Column(
                        children: [
                          Row(
                            children: [
                              DefaultText(
                                text: 'By Continuing you agree to our ',
                                fontSize: 12.sp,
                              ),
                              GestureDetector(
                                child: Text(' Privacy Policy ',style: linkStyle,),
                                onTap: () =>
                                    launchUrl(privacyUrl),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h,),
                          Row(
                            children: [
                              DefaultText(text:'and ' , fontSize: 12.sp,),
                              GestureDetector(
                                child: Text(' Terms of Service',style: linkStyle,),
                                onTap: () =>
                                    launchUrl(termsUrl),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],),
              ),
            ),
          ));
        },
    );
  }
}
