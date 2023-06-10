import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/shared/components/component/components.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../login_Screen/Login_screen.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../../shared/cubit/login_register_cubit/login_states.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  static String id = 'ResetPasswordScreen';
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var formKey = GlobalKey <FormState> ();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if(state is UpdatePasswordSuccess){
          Navigator.pushNamed(context, LoginScreen.id);
        }
      },
      builder: (context, state) {
        LoginCubit loginCubit = LoginCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: state is UpdatePasswordLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 85.h, horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/icon_key.svg'),
                        SizedBox(
                          height: 20.h,
                        ),
                        DefaultText(
                          text: 'Reset Password',
                          textStyle: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        DefaultText(
                          text: 'Enter your new password',
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        DefaultTextField(
                          borderRadius: 10.r,
                          color: Theme.of(context).focusColor,
                          hintText: 'Password',
                          obscureText: loginCubit.isResetPassword,
                          prefix: Padding(
                            padding: EdgeInsetsDirectional.only(start: 15.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icon_lock.svg',
                                  width: 16.w,
                                  height: 21.h,
                                ),
                              ],
                            ),
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              loginCubit.resetPasswordVisibility();
                            },
                            child: loginCubit.isResetPassword
                                ? Icon(Icons.visibility_off, color: silverColor,)
                                : Icon(Icons.visibility, color: silverColor,),
                          ),
                          textInputType: TextInputType.visiblePassword,
                          controller: newPasswordController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Required Field';
                            }
                            return null ;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        DefaultTextField(
                          borderRadius: 10.r,
                          color: Theme.of(context).focusColor,
                          hintText: 'Confirm Password',
                          obscureText: loginCubit.isResetConfirmPassword,
                          prefix: Padding(
                            padding: EdgeInsetsDirectional.only(start: 15.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icon_lock.svg',
                                  width: 16.w,
                                  height: 21.h,
                                ),
                              ],
                            ),
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              loginCubit.resetConfirmPasswordVisibility();
                            },
                            child: loginCubit.isResetConfirmPassword
                                ? Icon(
                                    Icons.visibility_off,
                                    color: silverColor,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: silverColor,
                                  ),
                          ),
                          textInputType: TextInputType.visiblePassword,
                          controller: confirmPasswordController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Required Field';
                            }
                            return null ;
                          },
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(formKey.currentState!.validate()){
                              if(newPasswordController.text == confirmPasswordController.text){
                                loginCubit.updatePassword(password: newPasswordController.text);
                              }else{
                                defaultSnackBar(
                                    context: context,
                                    text: 'Two password not matching',
                                    color: Colors.red
                                );
                              }
                            }
                          },
                          child: Container(
                            width: 237.w,
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: orangeColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                                child: DefaultText(
                              fontSize: 20.sp,
                              fontColor: whiteColor,
                              text: 'Submit',
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
