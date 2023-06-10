import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:talki/shared/components/component/components.dart';
import 'package:talki/shared/cubit/layout_cubt/layout_cubit.dart';
import '../../layout/home_layout_screen.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/styles.dart';
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
  var formKey = GlobalKey <FormState> ();

  ///////////////////////////////// Build Method
  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    return BlocConsumer <LoginCubit, LoginStates> (
        listener: (context, state){
          if (state is RegisterSuccessState){
            FirebaseAuth.instance.currentUser?.updateDisplayName('${firstNameController.text} ${lastNameController.text}');
            FirebaseAuth.instance.currentUser?.updatePhotoURL('${loginCubit.url}');
            LayoutCubit.get(context).pageIndex = 0 ;
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeLayoutScreen(
              emailId: emailId,
            )));
            //Navigator.pushNamed(context, HomeLayoutScreen.id, arguments: emailId);
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
            appBar: AppBar(automaticallyImplyLeading: false,),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 152.w,
                        child: DefaultText(
                          text: 'Create an account',
                          textStyle: Theme.of(context).textTheme.titleLarge,
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
                                      child: Image(image: NetworkImage('${loginCubit.url}'),)
                              )
                          ),
                        ),
                        fallback: (BuildContext context) => const Center(child: CircularProgressIndicator(),),
                      ),
                      SizedBox(height: 14.h,),
                      DefaultTextField(
                        controller: emailController,
                        color:  Theme.of(context).focusColor,
                        hintText: 'Email or phone number',
                        prefix: Icon(Icons.person, color: silverColor,),
                        textInputType: TextInputType.emailAddress,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 9.h,),
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                              color:  Theme.of(context).focusColor,
                              controller: firstNameController,
                              hintText: 'First name',
                              prefix: Icon(Icons.person, color: silverColor,),
                              textInputType: TextInputType.name,
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Required Field';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w,),
                          Expanded(
                            child: DefaultTextField(
                              color:  Theme.of(context).focusColor,
                              controller: lastNameController,
                              hintText: 'Last name',
                              prefix: Icon(Icons.person, color: silverColor,),
                              textInputType: TextInputType.name,
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Required Field';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      DefaultTextField(
                        color: Theme.of(context).focusColor,
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
                        textInputType: TextInputType.number,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h,),
                      DefaultTextField(
                        color: Theme.of(context).focusColor,
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
                        textInputType: TextInputType.number,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }else if (passwordController.text != ensurePasswordController.text){
                            return 'The password Not matching';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h,),
                      DefaultTextField(
                        color: Theme.of(context).focusColor,
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
                        validator: (value){
                          if(value.isEmpty){
                            return 'Required Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h,),
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
                          Expanded(child: DefaultText(
                            text: 'Register',
                            textStyle: Theme.of(context).textTheme.bodyLarge,)),
                          ConditionalBuilder(
                            condition: state is !RegisterLoadingState,
                            builder: (context) => GestureDetector(
                                onTap: (){
                                  if (formKey.currentState!.validate ()){
                                    if (passwordController.text != ensurePasswordController.text){
                                      defaultSnackBar(
                                          context: context,
                                          text: 'Two password not matching',
                                          color: Colors.red
                                      );
                                    }else{
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

                                    }
                                  }
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
            ),
          );
        },
    );
  }
}
