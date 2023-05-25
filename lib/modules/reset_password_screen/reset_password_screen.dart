import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../login_Screen/Login_screen.dart';
import '../login_Screen/login_cubit.dart';
import '../login_Screen/login_states.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static String id = 'ResetPasswordScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LoginCubit loginCubit = LoginCubit.get(context);
        return Scaffold(
          backgroundColor: scaffoldColorDark,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 85.h, horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/icon_key.svg'),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultText(
                        text: 'Reset Password',
                        fontColor: whiteColor,
                        fontSize: 32.sp,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      DefaultText(
                        text: 'Enter your new password',
                        fontColor: HexColor("#FFFFFF"),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300,
                      ),
                      SizedBox(
                        height: 36.h,
                      ),
                      DefaultTextField(
                        borderRadius: 10.r,
                        color: containerColor,
                        hintText: 'Password',
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
                            loginCubit.changePasswordVisibilityLogin();
                          },
                          child: loginCubit.isPasswordLogin
                              ? Icon(Icons.visibility_off, color: silverColor,)
                              : Icon(Icons.visibility, color: silverColor,),
                        ),
                        textInputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      DefaultTextField(
                        borderRadius: 10.r,
                        color: containerColor,
                        hintText: 'Confirm Password',
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
                            loginCubit.changePasswordVisibilityLogin();
                          },
                          child: loginCubit.isPasswordLogin
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
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.id);
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
        );
      },
    );
  }
}
