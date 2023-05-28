import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../layout/home_layout_screen.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/styles.dart';
import '../../shared/cubit/chat_cubit/chat_states.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../../shared/cubit/login_register_cubit/login_states.dart';

class RegisterScreen extends StatelessWidget {

  RegisterScreen({Key? key, this.emailId}) : super(key: key);

  ////////////////////////////////// variables
  static String id ='RegisterScreen';
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ensurePasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? emailId ;

  ///////////////////////////////// Build Method
  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer <LoginCubit, LoginStates> (
        listener: (context, state){
          if (state is RegisterSuccessState){
            Navigator.pushNamed(context, HomeLayoutScreen.id, arguments: emailId);
          }
          if(state is RegisterSuccessState || state is RegisterErrorState){
            emailController.clear();
            firstNameController.clear();
            lastNameController.clear();
            passwordController.clear();
            ensurePasswordController.clear();
            dateController.clear();
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 152.w,
                      child: DefaultText(
                        text: 'Create an account',
                        fontColor: whiteColor,
                        fontSize: 30.sp,
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    ConditionalBuilder(
                      condition: state is !UploadImageRegisterLoading,
                      builder: (context) => Center(
                        child: GestureDetector(
                            onTap: () async {
                              await loginCubit.uploadImage();
                            },
                            child: loginCubit.url == null ? SvgPicture.asset('assets/images/icon_camera.svg')
                                : Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image(image: NetworkImage('${loginCubit.url}'), )
                            )
                        ),
                      ),
                      fallback: (BuildContext context) => const Center(child: CircularProgressIndicator(),),
                    ),
                    SizedBox(height: 14.h,),
                    DefaultTextField(
                      controller: emailController,
                      color:  containerColor,
                      hintText: 'Email or phone number',
                      prefix: Icon(Icons.person, color: silverColor,),
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 9.h,),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextField(
                            color:  containerColor,
                            controller: firstNameController,
                            hintText: 'First name',
                            prefix: Icon(Icons.person, color: silverColor,),
                            textInputType: TextInputType.name,
                          ),
                        ),
                        SizedBox(width: 16.w,),
                        Expanded(
                          child: DefaultTextField(
                            color:  containerColor,
                            controller: lastNameController,
                            hintText: 'Last name',
                            prefix: Icon(Icons.person, color: silverColor,),
                            textInputType: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9.h,),
                    DefaultTextField(
                      color:  containerColor,
                      hintText: 'Password',
                      controller: passwordController,
                      prefix: Icon(Icons.lock, color: silverColor,),
                      obscureText: loginCubit.isPasswordRegisterNormal,
                      suffix: GestureDetector(
                        onTap: (){
                          loginCubit.changePasswordVisibilityRegister();
                        },
                        child: loginCubit.isPasswordRegisterNormal? Icon(Icons.visibility_off, color: silverColor,) : Icon(Icons.visibility, color: silverColor,),
                      ),
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 9.h,),
                    DefaultTextField(
                      color:  containerColor,
                      controller: ensurePasswordController,
                      obscureText: loginCubit.isEnsurePasswordRegister,
                      hintText: 'Confirm Password',
                      prefix: Icon(Icons.lock, color: silverColor,),
                      suffix: GestureDetector(
                        onTap: (){
                          loginCubit.changeEnsurePasswordVisibilityRegister();
                        },
                        child: loginCubit.isEnsurePasswordRegister? Icon(Icons.visibility_off, color: silverColor,) : Icon(Icons.visibility, color: silverColor,),
                      ),
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 9.h,),
                    DefaultTextField(
                      color:  containerColor,
                      controller: dateController,
                      hintText: 'Birthdate dd / mm / yy',
                      prefix: Icon(Icons.date_range, color: silverColor,),
                      textInputType: TextInputType.none,
                      onTap: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.parse('1990-01-01'),
                            lastDate:  DateTime.now(),
                        ).then((value){
                          dateController.text = DateFormat.yMMMd().format(value!);
                        });
                      },
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      padding: EdgeInsets.only(right: 63.w,),
                      child: RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children:<TextSpan> [
                            const TextSpan(text: '. By clicking the'),
                            TextSpan(text: ' Register', style: linkStyle,),
                            const TextSpan(text: ' button,you agree to\n'),
                            TextSpan(text: '  the public offer', style: defaultStyle ,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 23.h,),
                    Row(
                      children: [
                        Expanded(child: DefaultText(text: 'Register',fontColor: whiteColor,fontSize: 24.sp,)),
                        ConditionalBuilder(
                          condition: state is !RegisterLoadingState,
                          builder: (context) => GestureDetector(
                              onTap: (){
                                emailId = emailController.text;
                                 loginCubit.createUser(
                                   email: emailController.text,
                                   firstName: firstNameController.text,
                                   lastName: lastNameController.text,
                                   password: passwordController.text,
                                   ensurePassword: ensurePasswordController.text,
                                   date: dateController.text,
                                   urlImage: loginCubit.url,
                                   context: context
                                 );
                              },
                              child: SvgPicture.asset('assets/images/icon_arrow_right.svg')),
                          fallback: (context) => const Center(child: CircularProgressIndicator(),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
