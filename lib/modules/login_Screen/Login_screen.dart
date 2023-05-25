import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../layout/home_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../reset_password_screen/reset_password_screen.dart';
import 'login_cubit.dart';
import 'login_states.dart';
import '../forget_password_screen/forget_password_screen.dart';
import '../register_screen/register_screen.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, this.emailId}) : super(key: key);
  static String id = 'LoginScreen';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserCredential? credential;
  String? emailId;
  GlobalKey <FormState> formKey = GlobalKey <FormState>();

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer <LoginCubit, LoginStates> (
        listener: (context, state){
          if (state is LoginSuccessState ){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeLayoutScreen(emailId: emailId,)));
          }
          if (state is LoginWithGoogleSuccess){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeLayoutScreen(googleId: loginCubit.googleId,)));
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 54.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(image: const AssetImage(
                        'assets/images/talkiImage.png',),
                        width: 132.w,
                        height: 55.h,
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
                        color:  containerColor,
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
                        color:  containerColor,
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
                                    fontColor: orangeColor,
                                    text: 'Create a new account'
                                ),
                              )),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, ForgetPasswordScreen.id);
                            },
                            child: DefaultText(
                                fontColor: orangeColor,
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
                                  text: 'Sign in ',fontSize: 24.sp,
                                  fontColor: whiteColor,
                                ),
                              )),
                          ConditionalBuilder(
                            condition: state is !LoginLoadingState,
                            builder: (context) => GestureDetector(
                              onTap: () async {
                                emailId = emailController.text;
                                if(formKey.currentState!.validate()){
                                  await loginCubit.loginUserEmailAndPassword(emailController.text, passwordController.text, context);
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/images/icon_arrow_right.svg',
                              ),
                            ),
                            fallback: (context) => const Center (child: CircularProgressIndicator(),),
                          ),
                        ],
                      ),
                      SizedBox(height: 52.h,),
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
                          GestureDetector(
                              child:SvgPicture.asset('assets/images/icon_facebook.svg')
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },

    );
  }
}
