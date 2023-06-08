import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:talki/layout/home_layout_screen.dart';
import '../../shared/components/widgets/text_form_field.dart';
import '../../shared/components/widgets/text_widget.dart';
import '../../shared/constants/colors.dart';
import '../../shared/cubit/login_register_cubit/login_cubit.dart';
import '../../shared/cubit/login_register_cubit/login_states.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key, this.firstName, this.date, this.lastName, this.urlImage, this.emailAddress}) : super(key: key);
  static String id = 'Edit Profile';
  String? firstName;
  String? lastName;
  String? date;
  String? emailAddress;
  String? urlImage;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState(){
    firstNameController.text = "${widget.firstName}";
    lastNameController.text = "${widget.lastName}";
    dateController.text = "${widget.date}";
    LoginCubit.get(context).urlUpdate = "${widget.urlImage}";
    emailController.text = "${widget.emailAddress}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        return SafeArea(
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess){
                if(loginCubit.urlUpdate != null){
                  FirebaseAuth.instance.currentUser?.updatePhotoURL('${loginCubit.urlUpdate}');
                }
                FirebaseAuth.instance.currentUser?.
                  updateDisplayName('${firstNameController.text} ${lastNameController.text}');
                FirebaseAuth.instance.currentUser?.updateEmail(emailController.text);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => HomeLayoutScreen(isMenu: true,)), (route) => false);
              }
            },
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state is GetProfileDataLoading,
                child: ModalProgressHUD(
                  inAsyncCall: state is UpdateProfileLoading,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: orangeColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.elliptical(200.w, 40.h),
                                bottomLeft: Radius.elliptical(200.w, 40.h),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        width: 60.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Image(
                                          image: NetworkImage(
                                              '${FirebaseAuth.instance.currentUser?.photoURL}'),
                                        ))),
                                SizedBox(
                                  height: 10.h,
                                ),
                                DefaultText(
                                    fontSize: 22.sp,
                                    fontColor: whiteColor,
                                    fontWeight: FontWeight.w600,
                                    text:
                                        '${FirebaseAuth.instance.currentUser?.displayName}'),
                                DefaultText(
                                    fontColor: whiteColor,
                                    text:
                                        '${FirebaseAuth.instance.currentUser?.email}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          DefaultText(
                            text: 'Edit Profile',
                            fontColor: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                          ),
                          SizedBox(height: 27.h,),
                          ConditionalBuilder(
                            condition: state is !UpdateImageLoading,
                            builder: (context) => Center(
                              child: GestureDetector(
                                  onTap: () async {
                                    await loginCubit.updateImage();
                                  },
                                  child: loginCubit.urlUpdate == null ? SvgPicture.asset('assets/images/icon_camera.svg')
                                      : Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image(image: NetworkImage("${loginCubit.urlUpdate}"),)
                                  )
                              ),
                            ),
                            fallback: (BuildContext context) => const Center(child: CircularProgressIndicator(),),
                          ),
                          SizedBox(height: 27.h,),
                          Padding(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                DefaultTextField(
                                  onTap: () {},
                                  obscureText: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Required Field';
                                    }
                                    return null;
                                  },
                                  borderRadius: 10.r,
                                  color: containerColor,
                                  hintText: 'Date',
                                  prefix: Icon(
                                    Icons.email,
                                    color: silverColor,
                                  ),
                                  textInputType: TextInputType.emailAddress,
                                  controller: emailController,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DefaultTextField(
                                        onTap: () {},
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Required Field';
                                          }
                                          return null;
                                        },
                                        borderRadius: 10.r,
                                        color: containerColor,
                                        prefix: Icon(
                                          Icons.person,
                                          color: silverColor,
                                        ),
                                        hintText: 'First Name',
                                        textInputType: TextInputType.name,
                                        controller: firstNameController,
                                      ),
                                    ),
                                    SizedBox(width: 10.w,),
                                    Expanded(
                                      child: DefaultTextField(
                                        onTap: () {},
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Required Field';
                                          }
                                          return null;
                                        },
                                        borderRadius: 10.r,
                                        color: containerColor,
                                        prefix: Icon(
                                          Icons.person,
                                          color: silverColor,
                                        ),
                                        hintText: 'last Name',
                                        textInputType: TextInputType.name,
                                        controller: lastNameController,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                DefaultTextField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.parse('1990-01-01'),
                                      lastDate:  DateTime.now(),
                                    ).then((value){
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  obscureText: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Required Field';
                                    }
                                    return null;
                                  },
                                  borderRadius: 10.r,
                                  color: containerColor,
                                  hintText: 'Date',
                                  prefix: Icon(
                                    Icons.calendar_month,
                                    color: silverColor,
                                  ),
                                  textInputType: TextInputType.visiblePassword,
                                  controller: dateController,
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Container(
                                  width: 170.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: orangeColor,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                        loginCubit.updateProfile(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            date: dateController.text,
                                            urlImage: loginCubit.urlUpdate,
                                            emailAddress: emailController.text
                                        );
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          color: whiteColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
