import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/styles.dart';
import '../login_Screen/Login_screen.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../../shared/cubit/login_register_cubit/login_states.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);
  static String id = 'ForgetPasswordScreen';
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if(state is SendCodeSuccess){
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false,);
        }
      },
      builder: (context, state) {
        LoginCubit loginCubit = LoginCubit.get(context);
        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      text: 'Forget\nPassword?',
                      fontColor: whiteColor,
                      fontSize: 32.sp,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    DefaultTextField(
                      borderRadius: 10.r,
                      color: containerColor,
                      hintText: 'Enter your email',
                      prefix: Padding(
                        padding: EdgeInsetsDirectional.only(start: 15.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icon_message.svg',
                              width: 16.w,
                              height: 16.h,
                            ),
                          ],
                        ),
                      ),
                      textInputType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          const TextSpan(text: 'We will send you a '),
                          TextSpan(
                            text: ' message',
                            style: linkStyle,
                          ),
                          const TextSpan(text: ' to set or reset your'),
                          const TextSpan(
                            text: ' new password',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 56,
                    ),
                    Row(children: [
                      Expanded(
                          child: DefaultText(
                        text: 'Send Code',
                        fontColor: whiteColor,
                        fontSize: 24,
                      )),
                      ConditionalBuilder(
                        condition: state is !SendCodeLoading,
                        builder: (context) => GestureDetector(
                            onTap: () {
                              loginCubit.sendCodeResetPassword(email: emailController.text);
                            },
                            child: SvgPicture.asset(
                                'assets/images/icon_arrow_right.svg')),
                        fallback: (context) => const Center(child: CircularProgressIndicator(),),
                      ),
                    ]),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
